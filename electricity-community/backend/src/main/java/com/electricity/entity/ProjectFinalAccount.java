package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_final_account")
public class ProjectFinalAccount extends BaseEntity {
    private Long applicationId;
    private BigDecimal finalAmount;
    private String finalAccountPerson;
    private LocalDate finalAccountDate;
    private String registrarName;
    private LocalDateTime registerTime;
}
