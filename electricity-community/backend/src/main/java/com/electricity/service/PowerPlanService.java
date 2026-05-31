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
public class PowerPlanService {
    private final PowerPlanInfoMapper powerPlanInfoMapper;
    private final PowerSourceInfoMapper powerSourceInfoMapper;
    private final PlanTemplateMapper planTemplateMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingPlan(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "PLAN_DRAFT")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void savePowerPlan(Long applicationId, PowerPlanInfo planInfo,
                              List<PowerSourceInfo> powerSources,
                              Long operatorId, String operatorName) {
        planInfo.setApplicationId(applicationId);
        planInfo.setPlanVersion(planInfo.getPlanVersion() != null ? planInfo.getPlanVersion() : 1);
        powerPlanInfoMapper.insert(planInfo);

        if (powerSources != null) {
            for (PowerSourceInfo ps : powerSources) {
                ps.setApplicationId(applicationId);
                ps.setPowerPlanId(planInfo.getId());
                powerSourceInfoMapper.insert(ps);
            }
        }

        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "拟定供电方案完成", false, false);
    }

    public List<PowerPlanInfo> getPlanHistory(Long applicationId) {
        return powerPlanInfoMapper.selectList(
                new LambdaQueryWrapper<PowerPlanInfo>()
                        .eq(PowerPlanInfo::getApplicationId, applicationId)
                        .orderByDesc(PowerPlanInfo::getId)
        );
    }

    public List<PowerSourceInfo> getPowerSources(Long applicationId) {
        return powerSourceInfoMapper.selectList(
                new LambdaQueryWrapper<PowerSourceInfo>()
                        .eq(PowerSourceInfo::getApplicationId, applicationId)
        );
    }

    public List<PlanTemplate> getTemplates() {
        return planTemplateMapper.selectList(null);
    }
}
