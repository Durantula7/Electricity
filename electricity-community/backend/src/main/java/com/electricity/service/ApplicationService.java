package com.electricity.service;

import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.electricity.common.BusinessException;
import com.electricity.common.PageResult;
import com.electricity.entity.*;
import com.electricity.mapper.*;
import com.electricity.service.workflow.ProcessStatus;
import com.electricity.service.workflow.WorkflowEngine;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ApplicationService {

    private final ApplicationInfoMapper applicationInfoMapper;
    private final CustomerInfoMapper customerInfoMapper;
    private final ElectricalEquipmentMapper electricalEquipmentMapper;
    private final ReceivingEquipmentPlanMapper receivingEquipmentPlanMapper;
    private final CurrentProcessMapper currentProcessMapper;
    private final ProcessRecordMapper processRecordMapper;
    private final WorkflowEngine workflowEngine;

    @Transactional
    public ApplicationInfo createApplication(ApplicationInfo app, CustomerInfo customer,
                                              List<ElectricalEquipment> equipmentList,
                                              Long operatorId, String operatorName) {
        // Generate application number
        String appNo = "SQ" + DateUtil.format(new Date(), "yyyyMMddHHmmss");
        app.setApplicationNo(appNo);
        app.setProcessStatus(ProcessStatus.BUSINESS_ACCEPTANCE.getCode());
        app.setProcessStatusName(ProcessStatus.BUSINESS_ACCEPTANCE.getName());
        app.setAcceptUserId(operatorId);
        app.setAcceptUserName(operatorName);
        app.setAcceptTime(LocalDateTime.now());
        applicationInfoMapper.insert(app);

        // Save customer info
        if (customer != null) {
            customer.setApplicationId(app.getId());
            customerInfoMapper.insert(customer);
        }

        // Save equipment
        if (equipmentList != null) {
            for (ElectricalEquipment eq : equipmentList) {
                eq.setApplicationId(app.getId());
                electricalEquipmentMapper.insert(eq);
            }
        }

        // Create first process step
        CurrentProcess cp = new CurrentProcess();
        cp.setApplicationId(app.getId());
        cp.setCurrentStep(ProcessStatus.BUSINESS_ACCEPTANCE.getCode());
        cp.setCurrentStepName(ProcessStatus.BUSINESS_ACCEPTANCE.getName());
        cp.setStatus("processing");
        cp.setArriveTime(LocalDateTime.now());
        currentProcessMapper.insert(cp);

        // Record process
        ProcessRecord pr = new ProcessRecord();
        pr.setApplicationId(app.getId());
        pr.setProcessStep(ProcessStatus.BUSINESS_ACCEPTANCE.getCode());
        pr.setProcessStepName(ProcessStatus.BUSINESS_ACCEPTANCE.getName());
        pr.setOperatorId(operatorId);
        pr.setOperatorName(operatorName);
        pr.setOperation("create");
        pr.setOperationComment("创建申请");
        pr.setArriveTime(LocalDateTime.now());
        pr.setSendTime(LocalDateTime.now());
        processRecordMapper.insert(pr);

        return app;
    }

    public PageResult<ApplicationInfo> listApplications(Integer pageNum, Integer pageSize, String processStatus, String keyword) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(processStatus != null, ApplicationInfo::getProcessStatus, processStatus)
                .and(keyword != null, w -> w
                        .like(ApplicationInfo::getApplicationNo, keyword)
                        .or()
                        .like(ApplicationInfo::getCustomerName, keyword)
                )
                .orderByDesc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    public ApplicationInfo getApplicationDetail(Long id) {
        return applicationInfoMapper.selectById(id);
    }

    @Transactional
    public void submitApplication(Long id, Long operatorId, String operatorName,
                                   boolean hasProject, boolean skipDispatch) {
        workflowEngine.submitToNext(id, operatorId, operatorName, "提交", hasProject, skipDispatch);
    }

    public CustomerInfo getCustomerInfo(Long applicationId) {
        return customerInfoMapper.selectOne(
                new LambdaQueryWrapper<CustomerInfo>().eq(CustomerInfo::getApplicationId, applicationId)
        );
    }

    public List<ElectricalEquipment> getEquipmentList(Long applicationId) {
        return electricalEquipmentMapper.selectList(
                new LambdaQueryWrapper<ElectricalEquipment>().eq(ElectricalEquipment::getApplicationId, applicationId)
        );
    }

    public java.util.Map<String, Long> getDashboardStats() {
        java.util.Map<String, Long> stats = new java.util.LinkedHashMap<>();
        stats.put("total", applicationInfoMapper.selectCount(null));
        stats.put("businessAcceptance", applicationInfoMapper.selectCount(
                new LambdaQueryWrapper<ApplicationInfo>().eq(ApplicationInfo::getProcessStatus, "BUSINESS_ACCEPTANCE")));
        stats.put("surveyDispatch", applicationInfoMapper.selectCount(
                new LambdaQueryWrapper<ApplicationInfo>().eq(ApplicationInfo::getProcessStatus, "SURVEY_DISPATCH")));
        stats.put("fieldSurvey", applicationInfoMapper.selectCount(
                new LambdaQueryWrapper<ApplicationInfo>().eq(ApplicationInfo::getProcessStatus, "FIELD_SURVEY")));
        stats.put("approval", applicationInfoMapper.selectCount(
                new LambdaQueryWrapper<ApplicationInfo>().eq(ApplicationInfo::getProcessStatus, "APPROVAL")));
        stats.put("finished", applicationInfoMapper.selectCount(
                new LambdaQueryWrapper<ApplicationInfo>().eq(ApplicationInfo::getProcessStatus, "FINISHED")));
        return stats;
    }

    public List<ProcessRecord> getProcessHistory(Long applicationId) {
        return processRecordMapper.selectList(
                new LambdaQueryWrapper<ProcessRecord>()
                        .eq(ProcessRecord::getApplicationId, applicationId)
                        .orderByAsc(ProcessRecord::getSendTime)
        );
    }
}
