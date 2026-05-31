package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("plan_reply_info")
public class PlanReplyInfo extends BaseEntity {
    private Long applicationId;
    private Long replyPersonId;
    private String replyPersonName;
    private String replyMethod;
    private LocalDate replyDate;
    private String customerOpinion;
    private String customerSignee;
    private LocalDate customerSignDate;
    private LocalDateTime customerReplyTime;
    private String replyMode;
    private Integer isPrinted;
    private LocalDateTime printTime;
    private String printPerson;
}
