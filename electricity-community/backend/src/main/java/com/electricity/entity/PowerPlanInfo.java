package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("power_plan_info")
public class PowerPlanInfo extends BaseEntity {
    private Long applicationId;
    private BigDecimal approvedCapacity;
    private String planOpinion;
    private String planParticipants;
    private LocalDate planDate;
    private String powerSupplyMode;
    private String voltageLevel;
    private Integer canSupplyPower;
    private String powerSupplyUnit;
    private Integer hasProject;
    private Integer isTransfer;
    private String accessSystemPlan;
    private String receivingSystemPlan;
    private Integer planVersion;
}
