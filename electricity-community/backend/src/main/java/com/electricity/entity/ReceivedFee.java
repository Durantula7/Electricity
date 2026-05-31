package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("received_fee")
public class ReceivedFee extends BaseEntity {
    private Long applicationId;
    private Long receivableFeeId;
    private String feeProject;
    private BigDecimal receivableAmount;
    private BigDecimal receivedAmount;
    private BigDecimal unpaidAmount;
    private String paymentMethod;
    private Long collectorId;
    private String collectorName;
    private String collectDept;
    private LocalDateTime collectTime;
    private String invoiceNo;
    private Integer isPrinted;
    private String checkNo;
    private String checkBank;
    private String checkStatus;
}
