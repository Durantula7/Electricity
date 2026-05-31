package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("current_process")
public class CurrentProcess extends BaseEntity {
    private Long applicationId;
    private String currentStep;
    private String currentStepName;
    private Long currentHandlerId;
    private String currentHandlerName;
    private LocalDateTime arriveTime;
    private LocalDateTime deadlineTime;
    private String status;
    private Integer isOvertime;
}
