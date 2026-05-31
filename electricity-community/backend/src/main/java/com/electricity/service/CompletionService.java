package com.electricity.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.electricity.common.PageResult;
import com.electricity.entity.*;
import com.electricity.mapper.*;
import com.electricity.service.workflow.WorkflowEngine;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CompletionService {
    private final CompletionApplyInfoMapper completionApplyInfoMapper;
    private final CompletionCheckInfoMapper completionCheckInfoMapper;
    private final CompletionCheckDetailMapper completionCheckDetailMapper;
    private final RectificationNoticeMapper rectificationNoticeMapper;
    private final ReceivingEquipmentMapper receivingEquipmentMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    // --- Completion Apply ---
    public PageResult<ApplicationInfo> listPendingApply(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "COMPLETION_APPLY")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void saveApply(Long applicationId, CompletionApplyInfo applyInfo,
                          Long operatorId, String operatorName) {
        applyInfo.setApplicationId(applicationId);
        applyInfo.setApplyVersion(applyInfo.getApplyVersion() != null ? applyInfo.getApplyVersion() : 1);
        completionApplyInfoMapper.insert(applyInfo);
        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "竣工报验完成", false, false);
    }

    // --- Completion Check ---
    public PageResult<ApplicationInfo> listPendingCheck(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "COMPLETION_CHECK")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void saveCheck(Long applicationId, CompletionCheckInfo checkInfo,
                          List<CompletionCheckDetail> details,
                          List<RectificationNotice> notices,
                          List<ReceivingEquipment> equipment,
                          Long operatorId, String operatorName) {
        checkInfo.setApplicationId(applicationId);
        completionCheckInfoMapper.insert(checkInfo);

        if (details != null) {
            for (CompletionCheckDetail d : details) {
                d.setApplicationId(applicationId);
                d.setCheckId(checkInfo.getId());
                completionCheckDetailMapper.insert(d);
            }
        }

        if (notices != null) {
            for (RectificationNotice n : notices) {
                n.setApplicationId(applicationId);
                n.setCheckId(checkInfo.getId());
                rectificationNoticeMapper.insert(n);
            }
        }

        if (equipment != null) {
            for (ReceivingEquipment e : equipment) {
                e.setApplicationId(applicationId);
                receivingEquipmentMapper.insert(e);
            }
        }

        if (checkInfo.getIsQualified() != null && checkInfo.getIsQualified() == 1) {
            workflowEngine.submitToNext(applicationId, operatorId, operatorName, "竣工验收合格", false, false);
        } else {
            workflowEngine.reject(applicationId, operatorId, operatorName, "竣工验收不合格，退回竣工报验");
        }
    }
}
