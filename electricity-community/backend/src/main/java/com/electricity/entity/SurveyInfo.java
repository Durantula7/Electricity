package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("survey_info")
public class SurveyInfo extends BaseEntity {
    private Long applicationId;
    private Long surveyorId;
    private String surveyorName;
    private LocalDate surveyDate;
    private LocalDateTime surveyTime;
    private String surveyOpinion;
    private Integer canSupplyPower;
    private String cannotReason;
    private BigDecimal approvedCapacity;
    private String powerSupplyMode;
    private String voltageLevel;
    private String powerSupplyUnit;
    private Integer hasProject;
    private Integer isTransfer;
    private Integer surveyVersion;
}
