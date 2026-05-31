package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_construction")
public class ProjectConstruction extends BaseEntity {
    private Long applicationId;
    private String constructionUnit;
    private LocalDate startDate;
    private LocalDate completionDate;
    private LocalDate expectedCompletionDate;
    private Integer isOvertime;
    private String overtimeReason;
    private String registrarName;
    private LocalDateTime registerTime;
}
