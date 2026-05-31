package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("design_review_info")
public class DesignReviewInfo extends BaseEntity {
    private Long applicationId;
    private String designUnit;
    private String designQualification;
    private String submitUnit;
    private String submitPerson;
    private LocalDate submitDate;
    private String receiver;
    private String reviewer;
    private LocalDate reviewDate;
    private Integer civilDrawingsCount;
    private Integer lineDrawingsCount;
    private Integer substationDrawingsCount;
    private String reviewOpinion;
    private String registrarName;
    private LocalDateTime registerTime;
}
