package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_equipment_supply")
public class ProjectEquipmentSupply extends BaseEntity {
    private Long applicationId;
    private String supplyUnit;
    private String supplyContent;
    private String registrarName;
    private LocalDateTime registerTime;
}
