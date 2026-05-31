package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("receivable_fee")
public class ReceivableFee extends BaseEntity {
    private Long applicationId;
    private String feeProject;
    private BigDecimal receivableAmount;
    private LocalDateTime feeDetermineTime;
    private Long feeDeterminerId;
    private String feeDeterminerName;
    private String feeStandard;
    private Integer isPrinted;
}
