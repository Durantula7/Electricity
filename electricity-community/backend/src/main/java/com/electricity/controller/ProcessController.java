package com.electricity.controller;

import com.electricity.common.PageResult;
import com.electricity.common.Result;
import com.electricity.entity.*;
import com.electricity.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 统一的流程环节控制器 - 处理所有流程环节的查询和提交
 */
@RestController
@RequestMapping("/api/process")
@RequiredArgsConstructor
public class ProcessController {

    private final ApplicationService applicationService;
    private final SurveyDispatchService surveyDispatchService;
    private final SurveyInfoService surveyInfoService;
    private final PowerPlanService powerPlanService;
    private final ApprovalService approvalService;
    private final PlanReplyService planReplyService;
    private final FeeService feeService;
    private final ProjectTrackingService projectTrackingService;
    private final DesignReviewService designReviewService;
    private final MidInspectionService midInspectionService;
    private final CompletionService completionService;
    private final ArchiveService archiveService;

    // ==================== 勘查派工 ====================
    @GetMapping("/survey-dispatch/list")
    public Result<PageResult<ApplicationInfo>> listDispatch(@RequestParam(defaultValue = "1") Integer pageNum,
                                                             @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(surveyDispatchService.listPendingDispatch(pageNum, pageSize));
    }

    @PostMapping("/survey-dispatch/{applicationId}/dispatch")
    public Result<Void> dispatch(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        Long surveyorId = getLong(body, "surveyorId");
        String surveyorName = getStr(body, "surveyorName");
        Long dispatcherId = getLong(body, "operatorId");
        String dispatcherName = getStr(body, "operatorName");
        String dispatchMode = getStr(body, "dispatchMode");
        surveyDispatchService.dispatch(applicationId, surveyorId, surveyorName,
                dispatcherId != null ? dispatcherId : 3L,
                dispatcherName != null ? dispatcherName : "派工员",
                dispatchMode != null ? dispatchMode : "single");
        return Result.ok();
    }

    @PostMapping("/survey-dispatch/{applicationId}/recall")
    public Result<Void> recallDispatch(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        String reason = getStr(body, "reason");
        surveyDispatchService.recallDispatch(applicationId, getLong(body, "operatorId"),
                getStr(body, "operatorName"), reason != null ? reason : "");
        return Result.ok();
    }

    // ==================== 现场勘查 ====================
    @GetMapping("/field-survey/list")
    public Result<PageResult<ApplicationInfo>> listSurvey(@RequestParam(defaultValue = "1") Integer pageNum,
                                                           @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(surveyInfoService.listPendingSurvey(pageNum, pageSize));
    }

    @PostMapping("/field-survey/{applicationId}/save")
    public Result<Void> saveSurvey(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        Long operatorId = getLong(body, "operatorId");
        String operatorName = getStr(body, "operatorName");
        Boolean canSupplyPower = (Boolean) body.getOrDefault("canSupplyPower", true);

        SurveyInfo surveyInfo = new SurveyInfo();
        surveyInfo.setSurveyOpinion(getStr(body, "surveyOpinion"));
        surveyInfo.setApprovedCapacity(getDecimal(body, "approvedCapacity"));
        surveyInfo.setPowerSupplyMode(getStr(body, "powerSupplyMode"));
        surveyInfo.setVoltageLevel(getStr(body, "voltageLevel"));
        surveyInfo.setPowerSupplyUnit(getStr(body, "powerSupplyUnit"));
        surveyInfo.setHasProject(getInt(body, "hasProject"));
        surveyInfo.setIsTransfer(getInt(body, "isTransfer"));
        surveyInfo.setCannotReason(getStr(body, "cannotReason"));
        surveyInfo.setSurveyVersion(getInt(body, "surveyVersion"));

        surveyInfoService.saveSurvey(applicationId, surveyInfo, null,
                operatorId != null ? operatorId : 4L,
                operatorName != null ? operatorName : "勘查员",
                canSupplyPower != null && canSupplyPower);
        return Result.ok();
    }

    // ==================== 拟定供电方案 ====================
    @GetMapping("/power-plan/list")
    public Result<PageResult<ApplicationInfo>> listPlan(@RequestParam(defaultValue = "1") Integer pageNum,
                                                         @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(powerPlanService.listPendingPlan(pageNum, pageSize));
    }

    @PostMapping("/power-plan/{applicationId}/save")
    public Result<Void> savePlan(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        PowerPlanInfo planInfo = new PowerPlanInfo();
        planInfo.setPlanOpinion(getStr(body, "planOpinion"));
        planInfo.setPlanParticipants(getStr(body, "planParticipants"));
        planInfo.setApprovedCapacity(getDecimal(body, "approvedCapacity"));
        planInfo.setPowerSupplyMode(getStr(body, "powerSupplyMode"));
        planInfo.setVoltageLevel(getStr(body, "voltageLevel"));
        planInfo.setCanSupplyPower(getInt(body, "canSupplyPower"));
        planInfo.setPowerSupplyUnit(getStr(body, "powerSupplyUnit"));
        planInfo.setHasProject(getInt(body, "hasProject"));
        planInfo.setIsTransfer(getInt(body, "isTransfer"));
        planInfo.setAccessSystemPlan(getStr(body, "accessSystemPlan"));
        planInfo.setReceivingSystemPlan(getStr(body, "receivingSystemPlan"));

        powerPlanService.savePowerPlan(applicationId, planInfo, null,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 审批 ====================
    @GetMapping("/approval/list")
    public Result<PageResult<ApplicationInfo>> listApproval(@RequestParam(defaultValue = "1") Integer pageNum,
                                                             @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(approvalService.listPendingApproval(pageNum, pageSize));
    }

    @PostMapping("/approval/{applicationId}/approve")
    public Result<Void> approve(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        Boolean isApproved = (Boolean) body.getOrDefault("isApproved", true);
        String opinion = getStr(body, "opinion");
        approvalService.approve(applicationId,
                getLong(body, "operatorId"), getStr(body, "operatorName"),
                getStr(body, "dept"),
                isApproved != null && isApproved, opinion);
        return Result.ok();
    }

    // ==================== 答复供电方案 ====================
    @GetMapping("/plan-reply/list")
    public Result<PageResult<ApplicationInfo>> listReply(@RequestParam(defaultValue = "1") Integer pageNum,
                                                          @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(planReplyService.listPendingReply(pageNum, pageSize));
    }

    @PostMapping("/plan-reply/{applicationId}/save")
    public Result<Void> saveReply(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        PlanReplyInfo replyInfo = new PlanReplyInfo();
        replyInfo.setReplyMethod(getStr(body, "replyMethod"));
        replyInfo.setCustomerOpinion(getStr(body, "customerOpinion"));
        replyInfo.setCustomerSignee(getStr(body, "customerSignee"));
        replyInfo.setReplyMode(getStr(body, "replyMode"));
        planReplyService.saveReply(applicationId, replyInfo,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 确定费用 ====================
    @GetMapping("/fee-determine/list")
    public Result<PageResult<ApplicationInfo>> listFeeDetermine(@RequestParam(defaultValue = "1") Integer pageNum,
                                                                 @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(feeService.listPendingFeeDetermine(pageNum, pageSize));
    }

    @PostMapping("/fee-determine/{applicationId}/save")
    public Result<Void> determineFee(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        Boolean hasProject = (Boolean) body.getOrDefault("hasProject", false);
        List<ReceivableFee> fees = parseFees(body);
        feeService.determineFee(applicationId, fees,
                getLong(body, "operatorId"), getStr(body, "operatorName"),
                hasProject != null && hasProject);
        return Result.ok();
    }

    // ==================== 业务收费 ====================
    @GetMapping("/fee-collection/list")
    public Result<PageResult<ApplicationInfo>> listFeeCollection(@RequestParam(defaultValue = "1") Integer pageNum,
                                                                  @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(feeService.listPendingFeeCollection(pageNum, pageSize));
    }

    @PostMapping("/fee-collection/{applicationId}/collect")
    public Result<Void> collectFee(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        ReceivedFee fee = new ReceivedFee();
        fee.setReceivableFeeId(getLong(body, "receivableFeeId"));
        fee.setFeeProject(getStr(body, "feeProject"));
        fee.setReceivedAmount(getDecimal(body, "receivedAmount"));
        fee.setPaymentMethod(getStr(body, "paymentMethod"));
        fee.setCollectorId(getLong(body, "operatorId"));
        fee.setCollectorName(getStr(body, "operatorName"));
        fee.setCollectDept(getStr(body, "dept"));
        fee.setInvoiceNo(getStr(body, "invoiceNo"));
        feeService.collectFee(applicationId, fee);
        return Result.ok();
    }

    // ==================== 供电工程进度跟踪 ====================
    @GetMapping("/project-tracking/list")
    public Result<PageResult<ApplicationInfo>> listTracking(@RequestParam(defaultValue = "1") Integer pageNum,
                                                             @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(projectTrackingService.listPendingTracking(pageNum, pageSize));
    }

    @GetMapping("/project-tracking/{applicationId}/data")
    public Result<Object> trackingData(@PathVariable Long applicationId) {
        return Result.ok(projectTrackingService.getAllTrackingData(applicationId));
    }

    @PostMapping("/project-tracking/{applicationId}/submit")
    public Result<Void> submitTracking(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        projectTrackingService.submitTracking(applicationId,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 设计文件审核 ====================
    @GetMapping("/design-review/list")
    public Result<PageResult<ApplicationInfo>> listDesignReview(@RequestParam(defaultValue = "1") Integer pageNum,
                                                                 @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(designReviewService.listPendingReview(pageNum, pageSize));
    }

    @PostMapping("/design-review/{applicationId}/save")
    public Result<Void> saveDesignReview(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        DesignReviewInfo reviewInfo = new DesignReviewInfo();
        reviewInfo.setDesignUnit(getStr(body, "designUnit"));
        reviewInfo.setDesignQualification(getStr(body, "designQualification"));
        reviewInfo.setSubmitUnit(getStr(body, "submitUnit"));
        reviewInfo.setSubmitPerson(getStr(body, "submitPerson"));
        reviewInfo.setReceiver(getStr(body, "receiver"));
        reviewInfo.setReviewer(getStr(body, "reviewer"));
        reviewInfo.setReviewOpinion(getStr(body, "reviewOpinion"));
        reviewInfo.setRegistrarName(getStr(body, "registrarName"));
        designReviewService.saveReview(applicationId, reviewInfo,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 中间检查 ====================
    @GetMapping("/mid-inspection/list")
    public Result<PageResult<ApplicationInfo>> listMidInspection(@RequestParam(defaultValue = "1") Integer pageNum,
                                                                  @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(midInspectionService.listPendingInspection(pageNum, pageSize));
    }

    @PostMapping("/mid-inspection/{applicationId}/save")
    public Result<Void> saveMidInspection(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        MidInspectionInfo info = new MidInspectionInfo();
        info.setInspector(getStr(body, "inspector"));
        info.setInspectionContent(getStr(body, "inspectionContent"));
        info.setInspectionResult(getStr(body, "inspectionResult"));
        info.setDefectDescription(getStr(body, "defectDescription"));
        info.setRectificationRequired(getInt(body, "rectificationRequired"));
        midInspectionService.saveInspection(applicationId, info,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 竣工报验 ====================
    @GetMapping("/completion-apply/list")
    public Result<PageResult<ApplicationInfo>> listCompletionApply(@RequestParam(defaultValue = "1") Integer pageNum,
                                                                    @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(completionService.listPendingApply(pageNum, pageSize));
    }

    @PostMapping("/completion-apply/{applicationId}/save")
    public Result<Void> saveCompletionApply(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        CompletionApplyInfo applyInfo = new CompletionApplyInfo();
        applyInfo.setApplyUnit(getStr(body, "applyUnit"));
        applyInfo.setApplyPerson(getStr(body, "applyPerson"));
        applyInfo.setReceiver(getStr(body, "receiver"));
        applyInfo.setApplyRequirement(getStr(body, "applyRequirement"));
        completionService.saveApply(applicationId, applyInfo,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 竣工验收 ====================
    @GetMapping("/completion-check/list")
    public Result<PageResult<ApplicationInfo>> listCompletionCheck(@RequestParam(defaultValue = "1") Integer pageNum,
                                                                    @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(completionService.listPendingCheck(pageNum, pageSize));
    }

    @PostMapping("/completion-check/{applicationId}/save")
    public Result<Void> saveCompletionCheck(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        CompletionCheckInfo checkInfo = new CompletionCheckInfo();
        checkInfo.setCheckPerson(getStr(body, "checkPerson"));
        checkInfo.setCheckDept(getStr(body, "checkDept"));
        checkInfo.setIsQualified(getInt(body, "isQualified"));
        checkInfo.setOverallAssessment(getStr(body, "overallAssessment"));
        completionService.saveCheck(applicationId, checkInfo, null, null, null,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== 信息归档 ====================
    @GetMapping("/info-archive/list")
    public Result<PageResult<ApplicationInfo>> listArchive(@RequestParam(defaultValue = "1") Integer pageNum,
                                                            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.ok(archiveService.listPendingArchive(pageNum, pageSize));
    }

    @PostMapping("/info-archive/{applicationId}/archive")
    public Result<Void> archive(@PathVariable Long applicationId, @RequestBody Map<String, Object> body) {
        ArchiveInfo archiveInfo = new ArchiveInfo();
        archiveInfo.setArchiveNo(getStr(body, "archiveNo"));
        archiveInfo.setArchiveLocation(getStr(body, "archiveLocation"));
        archiveInfo.setMaterialList(getStr(body, "materialList"));
        archiveService.archive(applicationId, archiveInfo,
                getLong(body, "operatorId"), getStr(body, "operatorName"));
        return Result.ok();
    }

    // ==================== Helper ====================
    private String getStr(Map<String, Object> body, String key) {
        Object v = body.get(key);
        return v != null ? v.toString() : null;
    }

    private Long getLong(Map<String, Object> body, String key) {
        Object v = body.get(key);
        return v != null ? Long.parseLong(v.toString()) : null;
    }

    private Integer getInt(Map<String, Object> body, String key) {
        Object v = body.get(key);
        return v != null ? Integer.parseInt(v.toString()) : null;
    }

    private java.math.BigDecimal getDecimal(Map<String, Object> body, String key) {
        Object v = body.get(key);
        return v != null ? new java.math.BigDecimal(v.toString()) : null;
    }

    @SuppressWarnings("unchecked")
    private List<ReceivableFee> parseFees(Map<String, Object> body) {
        List<Map<String, Object>> feeList = (List<Map<String, Object>>) body.get("fees");
        if (feeList == null) return List.of();
        return feeList.stream().map(f -> {
            ReceivableFee fee = new ReceivableFee();
            fee.setFeeProject((String) f.get("feeProject"));
            fee.setReceivableAmount(new java.math.BigDecimal(f.get("receivableAmount").toString()));
            fee.setFeeStandard((String) f.get("feeStandard"));
            return fee;
        }).toList();
    }
}
