package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("approval_info")
public class ApprovalInfo extends BaseEntity {
    private Long applicationId;
    private String approvalLevel;
    private Long approverId;
    private String approverName;
    private String approvalDept;
    private Integer isApproved;
    private String approvalOpinion;
    private LocalDateTime approvalTime;
    private String approvalMode;
}
