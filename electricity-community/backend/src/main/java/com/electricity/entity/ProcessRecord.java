package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("process_record")
public class ProcessRecord extends BaseEntity {
    private Long applicationId;
    private String processStep;
    private String processStepName;
    private Long operatorId;
    private String operatorName;
    private String operation;
    private String operationComment;
    private LocalDateTime arriveTime;
    private LocalDateTime sendTime;
    private BigDecimal durationHours;
}
