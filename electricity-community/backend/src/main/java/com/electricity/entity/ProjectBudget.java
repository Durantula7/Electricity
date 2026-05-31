package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("project_budget")
public class ProjectBudget extends BaseEntity {
    private Long applicationId;
    private BigDecimal budgetAmount;
    private String budgetPerson;
    private LocalDate budgetDate;
    private String registrarName;
    private LocalDateTime registerTime;
}
