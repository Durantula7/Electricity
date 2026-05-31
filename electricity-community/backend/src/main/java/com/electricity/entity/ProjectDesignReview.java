package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_design_review")
public class ProjectDesignReview extends BaseEntity {
    private Long applicationId;
    private String submitUnit;
    private String submitPerson;
    private LocalDate submitDate;
    private String receiver;
    private String reviewer;
    private LocalDate reviewDate;
    private String reviewOpinion;
    private String registrarName;
    private LocalDateTime registerTime;
}
