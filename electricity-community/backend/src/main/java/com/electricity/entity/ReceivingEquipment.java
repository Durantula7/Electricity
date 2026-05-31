package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("receiving_equipment")
public class ReceivingEquipment extends BaseEntity {
    private Long applicationId;
    private String equipmentName;
    private String equipmentType;
    private String specification;
    private Integer quantity;
    private BigDecimal unitCapacity;
    private BigDecimal totalCapacity;
    private String voltageLevel;
    private String manufacturer;
    private String installationLocation;
}
