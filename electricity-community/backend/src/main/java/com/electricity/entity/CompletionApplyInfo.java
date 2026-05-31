package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("completion_apply_info")
public class CompletionApplyInfo extends BaseEntity {
    private Long applicationId;
    private String applyUnit;
    private String applyPerson;
    private String receiver;
    private LocalDateTime receiveTime;
    private String applyRequirement;
    private LocalDateTime plannedAcceptanceTime;
    private Integer applyVersion;
    private Integer materialComplete;
}
