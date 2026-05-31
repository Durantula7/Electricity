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

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ApprovalService {
    private final ApprovalInfoMapper approvalInfoMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingApproval(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "APPROVAL")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void approve(Long applicationId, Long approverId, String approverName,
                        String approvalDept, boolean isApproved, String opinion) {
        ApprovalInfo ai = new ApprovalInfo();
        ai.setApplicationId(applicationId);
        ai.setApproverId(approverId);
        ai.setApproverName(approverName);
        ai.setApprovalDept(approvalDept);
        ai.setIsApproved(isApproved ? 1 : 0);
        ai.setApprovalOpinion(opinion);
        ai.setApprovalTime(LocalDateTime.now());
        approvalInfoMapper.insert(ai);

        if (isApproved) {
            workflowEngine.submitToNext(applicationId, approverId, approverName, "审批通过", false, false);
        } else {
            workflowEngine.reject(applicationId, approverId, approverName, opinion != null ? opinion : "审批不通过");
        }
    }

    public List<ApprovalInfo> getApprovalHistory(Long applicationId) {
        return approvalInfoMapper.selectList(
                new LambdaQueryWrapper<ApprovalInfo>()
                        .eq(ApprovalInfo::getApplicationId, applicationId)
                        .orderByDesc(ApprovalInfo::getId)
        );
    }
}
