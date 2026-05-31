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
public class MidInspectionService {
    private final MidInspectionInfoMapper midInspectionInfoMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingInspection(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "MID_INSPECTION")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void saveInspection(Long applicationId, MidInspectionInfo info,
                               Long operatorId, String operatorName) {
        info.setApplicationId(applicationId);
        midInspectionInfoMapper.insert(info);
        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "中间检查完成", false, false);
    }
}
