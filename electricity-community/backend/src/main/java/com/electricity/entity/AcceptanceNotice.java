package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("acceptance_notice")
public class AcceptanceNotice extends BaseEntity {
    private Long applicationId;
    private String noticeContent;
    private String noticePerson;
    private LocalDateTime noticeTime;
    private String noticeDept;
}
