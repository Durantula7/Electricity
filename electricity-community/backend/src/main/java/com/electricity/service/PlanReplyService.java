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

@Service
@RequiredArgsConstructor
public class PlanReplyService {
    private final PlanReplyInfoMapper planReplyInfoMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingReply(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "PLAN_REPLY")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void saveReply(Long applicationId, PlanReplyInfo replyInfo,
                          Long operatorId, String operatorName) {
        replyInfo.setApplicationId(applicationId);
        replyInfo.setReplyPersonId(operatorId);
        replyInfo.setReplyPersonName(operatorName);
        planReplyInfoMapper.insert(replyInfo);
        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "答复供电方案完成", false, false);
    }
}
