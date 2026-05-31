package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("application_info")
public class ApplicationInfo extends BaseEntity {
    private String applicationNo;
    private String businessType;
    private Long customerId;
    private String customerName;
    private String district;
    private String electricityAddress;
    private String contactPerson;
    private String contactPhone;
    private String certType;
    private String certNo;
    private String electricityCategory;
    private BigDecimal capacity;
    private String industryCategory;
    private String loadNature;
    private String powerSupplyUnit;
    private Integer householdCount;
    private String remark;
    private String processStatus;
    private String processStatusName;
    private Integer isIntercity;
    private String intercityLocation;
    private Integer isHighRisk;
    private Integer isDishonest;
    private Long acceptUserId;
    private String acceptUserName;
    private LocalDateTime acceptTime;
}
