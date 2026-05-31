package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_fee_collection")
public class ProjectFeeCollection extends BaseEntity {
    private Long applicationId;
    private String feeProject;
    private String feePerson;
    private LocalDateTime feeTime;
    private BigDecimal receivedAmount;
}
