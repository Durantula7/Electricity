package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_quality_supervision")
public class ProjectQualitySupervision extends BaseEntity {
    private Long applicationId;
    private String supervisionUnit;
    private String supervisionResult;
    private String inspector;
    private LocalDateTime inspectionTime;
    private String qualityRating;
}
