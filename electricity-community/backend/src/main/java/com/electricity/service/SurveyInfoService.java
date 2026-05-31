package com.electricity.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.electricity.common.BusinessException;
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
public class SurveyInfoService {
    private final SurveyInfoMapper surveyInfoMapper;
    private final PowerSourceInfoMapper powerSourceInfoMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingSurvey(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "FIELD_SURVEY")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void saveSurvey(Long applicationId, SurveyInfo surveyInfo,
                           List<PowerSourceInfo> powerSources,
                           Long operatorId, String operatorName,
                           boolean canSupplyPower) {
        if (!canSupplyPower && (surveyInfo.getCannotReason() == null || surveyInfo.getCannotReason().isBlank())) {
            throw new BusinessException("不可供电时必须说明原因");
        }
        surveyInfo.setApplicationId(applicationId);
        surveyInfo.setSurveyorId(operatorId);
        surveyInfo.setSurveyorName(operatorName);
        surveyInfo.setSurveyTime(LocalDateTime.now());
        surveyInfo.setCanSupplyPower(canSupplyPower ? 1 : 0);
        surveyInfo.setSurveyVersion(surveyInfo.getSurveyVersion() != null ? surveyInfo.getSurveyVersion() : 1);
        surveyInfoMapper.insert(surveyInfo);

        if (canSupplyPower && powerSources != null) {
            for (PowerSourceInfo ps : powerSources) {
                ps.setApplicationId(applicationId);
                powerSourceInfoMapper.insert(ps);
            }
        }

        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "现场勘查完成", false, false);
    }

    public List<SurveyInfo> getSurveyHistory(Long applicationId) {
        return surveyInfoMapper.selectList(
                new LambdaQueryWrapper<SurveyInfo>()
                        .eq(SurveyInfo::getApplicationId, applicationId)
                        .orderByDesc(SurveyInfo::getId)
        );
    }
}
