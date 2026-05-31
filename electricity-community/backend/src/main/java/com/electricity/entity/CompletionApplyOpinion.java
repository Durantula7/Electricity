package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("completion_apply_opinion")
public class CompletionApplyOpinion extends BaseEntity {
    private Long applicationId;
    private Long applyId;
    private String opinionContent;
    private String opinionPerson;
    private LocalDateTime opinionTime;
}
