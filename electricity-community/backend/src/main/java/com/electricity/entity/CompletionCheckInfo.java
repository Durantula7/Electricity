package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("completion_check_info")
public class CompletionCheckInfo extends BaseEntity {
    private Long applicationId;
    private String checkPerson;
    private String checkDept;
    private LocalDateTime checkTime;
    private Integer isQualified;
    private String overallAssessment;
    private Integer checkVersion;
}
