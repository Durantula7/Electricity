package com.electricity.service.workflow;

import lombok.Getter;
import java.util.*;

@Getter
public enum ProcessStatus {
    BUSINESS_ACCEPTANCE("BUSINESS_ACCEPTANCE", "业务受理", 1),
    SURVEY_DISPATCH("SURVEY_DISPATCH", "勘查派工", 2),
    FIELD_SURVEY("FIELD_SURVEY", "现场勘查", 3),
    PLAN_DRAFT("PLAN_DRAFT", "拟定供电方案", 4),
    APPROVAL("APPROVAL", "审批", 5),
    PLAN_REPLY("PLAN_REPLY", "答复供电方案", 6),
    FEE_DETERMINE("FEE_DETERMINE", "确定费用", 7),
    FEE_COLLECTION("FEE_COLLECTION", "业务收费", 8),
    PROJECT_TRACKING("PROJECT_TRACKING", "供电工程进度跟踪", 9),
    DESIGN_REVIEW("DESIGN_REVIEW", "设计文件审核", 10),
    MID_INSPECTION("MID_INSPECTION", "中间检查", 11),
    COMPLETION_APPLY("COMPLETION_APPLY", "竣工报验", 12),
    COMPLETION_CHECK("COMPLETION_CHECK", "竣工验收", 13),
    INFO_ARCHIVE("INFO_ARCHIVE", "信息归档", 14),
    ARCHIVE("ARCHIVE", "归档", 15),
    FINISHED("FINISHED", "已办结", 16);

    private final String code;
    private final String name;
    private final int order;

    ProcessStatus(String code, String name, int order) {
        this.code = code;
        this.name = name;
        this.order = order;
    }

    private static final Map<String, ProcessStatus> CODE_MAP = new LinkedHashMap<>();
    static {
        for (ProcessStatus ps : values()) {
            CODE_MAP.put(ps.code, ps);
        }
    }

    public static ProcessStatus fromCode(String code) {
        return CODE_MAP.get(code);
    }

    /**
     * 获取下一个状态（标准路径）
     */
    public ProcessStatus next() {
        ProcessStatus[] all = values();
        int idx = ordinal();
        if (idx < all.length - 1) {
            return all[idx + 1];
        }
        return this;
    }

    /**
     * 审批不通过时，退回到现场勘查
     */
    public boolean canRejectToSurvey() {
        return this == APPROVAL;
    }

    /**
     * 竣工验收不通过时，退回到竣工报验
     */
    public boolean canRejectToCompletionApply() {
        return this == COMPLETION_CHECK;
    }

    /**
     * 业务受理是否跳过勘查派工（可选跳过）
     */
    public boolean canSkipDispatch() {
        return this == BUSINESS_ACCEPTANCE;
    }

    /**
     * 是否有供电工程（并行触发工程跟踪和设计审核）
     */
    public boolean needsProjectTracking() {
        return this == FEE_COLLECTION;
    }

    /**
     * 工单完成后的目标状态
     */
    public ProcessStatus getRejectTarget() {
        if (this == APPROVAL) return FIELD_SURVEY;
        if (this == COMPLETION_CHECK) return COMPLETION_APPLY;
        return this;
    }
}
