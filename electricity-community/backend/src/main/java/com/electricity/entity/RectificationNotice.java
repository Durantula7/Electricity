package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("rectification_notice")
public class RectificationNotice extends BaseEntity {
    private Long applicationId;
    private Long checkId;
    private String noticeContent;
    private LocalDate rectificationDeadline;
    private String issuer;
    private LocalDateTime issueTime;
    private String rectificationResult;
    private String resultConfirmPerson;
    private LocalDateTime resultConfirmTime;
}
