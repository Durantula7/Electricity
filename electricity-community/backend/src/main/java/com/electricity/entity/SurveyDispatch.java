package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("survey_dispatch")
public class SurveyDispatch extends BaseEntity {
    private Long applicationId;
    private String dispatchMode;
    private Long surveyorId;
    private String surveyorName;
    private Long dispatcherId;
    private String dispatcherName;
    private LocalDateTime dispatchTime;
    private String status;
    private LocalDateTime recallTime;
    private String recallReason;
}
