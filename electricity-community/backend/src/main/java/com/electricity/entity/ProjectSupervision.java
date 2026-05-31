package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_supervision")
public class ProjectSupervision extends BaseEntity {
    private Long applicationId;
    private String supervisionUnit;
    private String supervisor;
    private String supervisionContent;
    private LocalDate startDate;
    private LocalDate endDate;
}
