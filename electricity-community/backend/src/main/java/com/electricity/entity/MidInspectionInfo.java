package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("mid_inspection_info")
public class MidInspectionInfo extends BaseEntity {
    private Long applicationId;
    private String inspector;
    private LocalDate inspectionDate;
    private String inspectionContent;
    private String inspectionResult;
    private String defectDescription;
    private Integer rectificationRequired;
    private LocalDate rectificationDeadline;
    private String rectificationResult;
    private Integer isPrinted;
}
