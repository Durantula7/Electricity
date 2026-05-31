package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("customer_info")
public class CustomerInfo extends BaseEntity {
    private Long applicationId;
    private String customerName;
    private String certType;
    private String certNo;
    private String legalRepresentative;
    private String registeredCapital;
    private String businessScope;
    private String address;
    private String contactPerson;
    private String contactPhone;
    private String postCode;
    private String businessLicenseNo;
    private String organizationCode;
    private String customerType;
}
