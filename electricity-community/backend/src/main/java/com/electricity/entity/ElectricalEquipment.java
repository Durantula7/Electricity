package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("electrical_equipment")
public class ElectricalEquipment extends BaseEntity {
    private Long applicationId;
    private String equipmentName;
    private String equipmentType;
    private Integer quantity;
    private BigDecimal unitCapacity;
    private BigDecimal totalCapacity;
    private String voltageLevel;
    private String phaseType;
    private String remark;
}
