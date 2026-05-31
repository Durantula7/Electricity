package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("plan_template")
public class PlanTemplate extends BaseEntity {
    private String templateName;
    private String templateCode;
    private BigDecimal capacityMin;
    private BigDecimal capacityMax;
    private String voltageLevel;
    private String powerSupplyMode;
    private String templateContent;
}
