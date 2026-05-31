package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("power_source_info")
public class PowerSourceInfo extends BaseEntity {
    private Long applicationId;
    private Long powerPlanId;
    private String sourceNature;
    private String sourceType;
    private String operationMode;
    private String substation;
    private String lineName;
    private String supplyVoltage;
    private BigDecimal supplyCapacity;
    private String incomingMode;
    private String propertyBoundary;
    private String incomingPoleNo;
    private String protectionMode;
    private Integer loopCount;
    private String lineLaying;
    private String meteringPoint;
}
