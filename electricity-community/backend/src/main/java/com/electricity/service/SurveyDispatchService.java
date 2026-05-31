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
public class SurveyDispatchService {
    private final SurveyDispatchMapper surveyDispatchMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingDispatch(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "SURVEY_DISPATCH")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void dispatch(Long applicationId, Long surveyorId, String surveyorName,
                         Long dispatcherId, String dispatcherName, String dispatchMode) {
        SurveyDispatch sd = new SurveyDispatch();
        sd.setApplicationId(applicationId);
        sd.setSurveyorId(surveyorId);
        sd.setSurveyorName(surveyorName);
        sd.setDispatcherId(dispatcherId);
        sd.setDispatcherName(dispatcherName);
        sd.setDispatchMode(dispatchMode);
        sd.setDispatchTime(LocalDateTime.now());
        sd.setStatus("dispatched");
        surveyDispatchMapper.insert(sd);
        workflowEngine.submitToNext(applicationId, dispatcherId, dispatcherName, "派工完成", false, false);
    }

    @Transactional
    public void recallDispatch(Long applicationId, Long operatorId, String operatorName, String reason) {
        SurveyDispatch sd = surveyDispatchMapper.selectOne(
                new LambdaQueryWrapper<SurveyDispatch>()
                        .eq(SurveyDispatch::getApplicationId, applicationId)
                        .eq(SurveyDispatch::getStatus, "dispatched")
                        .orderByDesc(SurveyDispatch::getId)
                        .last("LIMIT 1")
        );
        if (sd != null) {
            sd.setStatus("recalled");
            sd.setRecallTime(LocalDateTime.now());
            sd.setRecallReason(reason);
            surveyDispatchMapper.updateById(sd);
        }
        workflowEngine.recall(applicationId, operatorId, operatorName);
    }

    public List<SurveyDispatch> getDispatchHistory(Long applicationId) {
        return surveyDispatchMapper.selectList(
                new LambdaQueryWrapper<SurveyDispatch>()
                        .eq(SurveyDispatch::getApplicationId, applicationId)
                        .orderByDesc(SurveyDispatch::getId)
        );
    }
}
