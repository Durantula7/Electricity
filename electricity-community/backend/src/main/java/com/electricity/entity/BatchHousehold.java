package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("batch_household")
public class BatchHousehold extends BaseEntity {
    private Long applicationId;
    private String householdName;
    private String electricityAddress;
    private String electricityCategory;
    private BigDecimal capacity;
    private String customerType;
}
