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
public class ProjectTrackingService {
    private final ProjectDesignInfoMapper projectDesignInfoMapper;
    private final ProjectDesignReviewMapper projectDesignReviewMapper;
    private final ProjectBudgetMapper projectBudgetMapper;
    private final ProjectFeeCollectionMapper projectFeeCollectionMapper;
    private final ProjectEquipmentSupplyMapper projectEquipmentSupplyMapper;
    private final ProjectConstructionMapper projectConstructionMapper;
    private final ProjectFinalAccountMapper projectFinalAccountMapper;
    private final ProjectQualitySupervisionMapper projectQualitySupervisionMapper;
    private final ProjectSupervisionMapper projectSupervisionMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingTracking(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "PROJECT_TRACKING")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void submitTracking(Long applicationId, Long operatorId, String operatorName) {
        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "供电工程进度跟踪完成", false, false);
    }

    // Convenience methods for saving each sub-type
    public void saveDesignInfo(ProjectDesignInfo info) { projectDesignInfoMapper.insert(info); }
    public void saveDesignReview(ProjectDesignReview info) { projectDesignReviewMapper.insert(info); }
    public void saveBudget(ProjectBudget info) { projectBudgetMapper.insert(info); }
    public void saveFeeCollection(ProjectFeeCollection info) { projectFeeCollectionMapper.insert(info); }
    public void saveEquipmentSupply(ProjectEquipmentSupply info) { projectEquipmentSupplyMapper.insert(info); }
    public void saveConstruction(ProjectConstruction info) { projectConstructionMapper.insert(info); }
    public void saveFinalAccount(ProjectFinalAccount info) { projectFinalAccountMapper.insert(info); }
    public void saveQualitySupervision(ProjectQualitySupervision info) { projectQualitySupervisionMapper.insert(info); }
    public void saveSupervision(ProjectSupervision info) { projectSupervisionMapper.insert(info); }

    public Object getAllTrackingData(Long applicationId) {
        var result = new java.util.HashMap<String, Object>();
        result.put("designInfo", projectDesignInfoMapper.selectList(new LambdaQueryWrapper<ProjectDesignInfo>().eq(ProjectDesignInfo::getApplicationId, applicationId)));
        result.put("designReview", projectDesignReviewMapper.selectList(new LambdaQueryWrapper<ProjectDesignReview>().eq(ProjectDesignReview::getApplicationId, applicationId)));
        result.put("budget", projectBudgetMapper.selectList(new LambdaQueryWrapper<ProjectBudget>().eq(ProjectBudget::getApplicationId, applicationId)));
        result.put("feeCollection", projectFeeCollectionMapper.selectList(new LambdaQueryWrapper<ProjectFeeCollection>().eq(ProjectFeeCollection::getApplicationId, applicationId)));
        result.put("equipmentSupply", projectEquipmentSupplyMapper.selectList(new LambdaQueryWrapper<ProjectEquipmentSupply>().eq(ProjectEquipmentSupply::getApplicationId, applicationId)));
        result.put("construction", projectConstructionMapper.selectList(new LambdaQueryWrapper<ProjectConstruction>().eq(ProjectConstruction::getApplicationId, applicationId)));
        result.put("finalAccount", projectFinalAccountMapper.selectList(new LambdaQueryWrapper<ProjectFinalAccount>().eq(ProjectFinalAccount::getApplicationId, applicationId)));
        result.put("qualitySupervision", projectQualitySupervisionMapper.selectList(new LambdaQueryWrapper<ProjectQualitySupervision>().eq(ProjectQualitySupervision::getApplicationId, applicationId)));
        result.put("supervision", projectSupervisionMapper.selectList(new LambdaQueryWrapper<ProjectSupervision>().eq(ProjectSupervision::getApplicationId, applicationId)));
        return result;
    }
}
