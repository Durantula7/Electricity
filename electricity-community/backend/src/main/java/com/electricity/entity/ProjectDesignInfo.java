package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_design_info")
public class ProjectDesignInfo extends BaseEntity {
    private Long applicationId;
    private String projectName;
    private String designUnit;
    private String designContent;
    private LocalDate designCompleteTime;
    private String designUnitQualification;
    private Long registrarId;
    private String registrarName;
    private LocalDateTime registerTime;
}
