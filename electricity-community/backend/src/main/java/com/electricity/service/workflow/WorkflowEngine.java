package com.electricity.service.workflow;

import cn.hutool.core.date.LocalDateTimeUtil;
import com.electricity.common.BusinessException;
import com.electricity.entity.ApplicationInfo;
import com.electricity.entity.CurrentProcess;
import com.electricity.entity.ProcessRecord;
import com.electricity.mapper.ApplicationInfoMapper;
import com.electricity.mapper.CurrentProcessMapper;
import com.electricity.mapper.ProcessRecordMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@Service
@RequiredArgsConstructor
public class WorkflowEngine {

    private final ApplicationInfoMapper applicationInfoMapper;
    private final CurrentProcessMapper currentProcessMapper;
    private final ProcessRecordMapper processRecordMapper;

    @Transactional
    public void submitToNext(Long applicationId, Long operatorId, String operatorName,
                             String operationComment, boolean hasProject, boolean skipDispatch) {
        ApplicationInfo app = applicationInfoMapper.selectById(applicationId);
        if (app == null) throw new BusinessException("申请单不存在");

        ProcessStatus currentStatus = ProcessStatus.fromCode(app.getProcessStatus());
        if (currentStatus == null) throw new BusinessException("未知流程状态");

        // 记录当前环节完成
        completeCurrentProcess(applicationId, operatorId, operatorName, operationComment);

        // 确定目标状态
        ProcessStatus targetStatus;
        if (currentStatus.canSkipDispatch() && skipDispatch) {
            targetStatus = ProcessStatus.FIELD_SURVEY;
        } else if (currentStatus.needsProjectTracking() && hasProject) {
            targetStatus = ProcessStatus.PROJECT_TRACKING;
        } else {
            targetStatus = currentStatus.next();
        }

        // 更新申请单状态
        app.setProcessStatus(targetStatus.getCode());
        app.setProcessStatusName(targetStatus.getName());
        applicationInfoMapper.updateById(app);

        // 创建新环节
        createCurrentProcess(applicationId, targetStatus);

        // 记录流程日志
        saveProcessRecord(applicationId, currentStatus, operatorId, operatorName,
                "submit", operationComment, null);
    }

    @Transactional
    public void reject(Long applicationId, Long operatorId, String operatorName,
                       String rejectReason) {
        ApplicationInfo app = applicationInfoMapper.selectById(applicationId);
        if (app == null) throw new BusinessException("申请单不存在");

        ProcessStatus currentStatus = ProcessStatus.fromCode(app.getProcessStatus());
        if (currentStatus == null) throw new BusinessException("未知流程状态");

        ProcessStatus targetStatus = currentStatus.getRejectTarget();
        if (targetStatus == currentStatus) {
            throw new BusinessException("当前环节不支持退回操作");
        }

        // 记录当前环节完成
        completeCurrentProcess(applicationId, operatorId, operatorName, "退回: " + rejectReason);

        // 退回
        app.setProcessStatus(targetStatus.getCode());
        app.setProcessStatusName(targetStatus.getName());
        applicationInfoMapper.updateById(app);

        createCurrentProcess(applicationId, targetStatus);
        saveProcessRecord(applicationId, currentStatus, operatorId, operatorName,
                "reject", rejectReason, null);
    }

    @Transactional
    public void recall(Long applicationId, Long operatorId, String operatorName) {
        ApplicationInfo app = applicationInfoMapper.selectById(applicationId);
        if (app == null) throw new BusinessException("申请单不存在");

        ProcessStatus currentStatus = ProcessStatus.fromCode(app.getProcessStatus());
        if (currentStatus == null || currentStatus.ordinal() <= 1) {
            throw new BusinessException("无法召回，已是初始环节");
        }

        ProcessStatus[] all = ProcessStatus.values();
        ProcessStatus prevStatus = all[currentStatus.ordinal() - 1];

        completeCurrentProcess(applicationId, operatorId, operatorName, "召回重新派工");

        app.setProcessStatus(prevStatus.getCode());
        app.setProcessStatusName(prevStatus.getName());
        applicationInfoMapper.updateById(app);

        createCurrentProcess(applicationId, prevStatus);
        saveProcessRecord(applicationId, currentStatus, operatorId, operatorName,
                "recall", "召回重新派工", null);
    }

    private void completeCurrentProcess(Long appId, Long operatorId, String operatorName, String comment) {
        CurrentProcess cp = currentProcessMapper.selectOne(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<CurrentProcess>()
                        .eq(CurrentProcess::getApplicationId, appId)
                        .eq(CurrentProcess::getStatus, "processing")
        );
        if (cp != null) {
            cp.setStatus("completed");
            cp.setCurrentHandlerId(operatorId);
            cp.setCurrentHandlerName(operatorName);
            currentProcessMapper.updateById(cp);
        }
    }

    private void createCurrentProcess(Long appId, ProcessStatus status) {
        CurrentProcess cp = new CurrentProcess();
        cp.setApplicationId(appId);
        cp.setCurrentStep(status.getCode());
        cp.setCurrentStepName(status.getName());
        cp.setStatus("processing");
        cp.setArriveTime(LocalDateTime.now());
        currentProcessMapper.insert(cp);
    }

    private void saveProcessRecord(Long appId, ProcessStatus step, Long operatorId,
                                    String operatorName, String operation, String comment,
                                    LocalDateTime arriveTime) {
        ProcessRecord record = new ProcessRecord();
        record.setApplicationId(appId);
        record.setProcessStep(step.getCode());
        record.setProcessStepName(step.getName());
        record.setOperatorId(operatorId);
        record.setOperatorName(operatorName);
        record.setOperation(operation);
        record.setOperationComment(comment);
        record.setArriveTime(arriveTime != null ? arriveTime : LocalDateTime.now());
        record.setSendTime(LocalDateTime.now());

        // 计算处理时长
        if (arriveTime != null) {
            long hours = ChronoUnit.MINUTES.between(arriveTime, LocalDateTime.now());
            record.setDurationHours(BigDecimal.valueOf(hours).divide(BigDecimal.valueOf(60), 2, RoundingMode.HALF_UP));
        }
        processRecordMapper.insert(record);
    }
}
