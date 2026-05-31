package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("completion_check_detail")
public class CompletionCheckDetail extends BaseEntity {
    private Long applicationId;
    private Long checkId;
    private String checkItem;
    private String checkStandard;
    private String checkResult;
    private Integer isQualified;
    private String remark;
}
