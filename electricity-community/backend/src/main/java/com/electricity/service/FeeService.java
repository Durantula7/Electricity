package com.electricity.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.electricity.common.BusinessException;
import com.electricity.common.PageResult;
import com.electricity.entity.*;
import com.electricity.mapper.*;
import com.electricity.service.workflow.WorkflowEngine;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FeeService {
    private final ReceivableFeeMapper receivableFeeMapper;
    private final ReceivedFeeMapper receivedFeeMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    // --- Fee Determination ---
    public PageResult<ApplicationInfo> listPendingFeeDetermine(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "FEE_DETERMINE")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void determineFee(Long applicationId, List<ReceivableFee> fees,
                             Long operatorId, String operatorName, boolean hasProject) {
        for (ReceivableFee fee : fees) {
            fee.setApplicationId(applicationId);
            fee.setFeeDetermineTime(LocalDateTime.now());
            fee.setFeeDeterminerId(operatorId);
            fee.setFeeDeterminerName(operatorName);
            receivableFeeMapper.insert(fee);
        }
        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "费用已确定", hasProject, false);
    }

    public List<ReceivableFee> getReceivableFees(Long applicationId) {
        return receivableFeeMapper.selectList(
                new LambdaQueryWrapper<ReceivableFee>()
                        .eq(ReceivableFee::getApplicationId, applicationId)
        );
    }

    // --- Fee Collection ---
    public PageResult<ApplicationInfo> listPendingFeeCollection(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "FEE_COLLECTION")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void collectFee(Long applicationId, ReceivedFee receivedFee) {
        ReceivableFee receivable = receivableFeeMapper.selectById(receivedFee.getReceivableFeeId());
        if (receivable == null) throw new BusinessException("应收费用记录不存在");

        receivedFee.setApplicationId(applicationId);
        receivedFee.setReceivableAmount(receivable.getReceivableAmount());
        receivedFee.setCollectTime(LocalDateTime.now());
        receivedFee.setUnpaidAmount(receivable.getReceivableAmount().subtract(
                receivedFee.getReceivedAmount() != null ? receivedFee.getReceivedAmount() : BigDecimal.ZERO));
        receivedFeeMapper.insert(receivedFee);

        boolean allPaid = checkAllFeesPaid(applicationId);
        if (allPaid) {
            workflowEngine.submitToNext(applicationId, receivedFee.getCollectorId(),
                    receivedFee.getCollectorName(), "费用已收讫", false, false);
        }
    }

    private boolean checkAllFeesPaid(Long applicationId) {
        List<ReceivableFee> receivable = getReceivableFees(applicationId);
        BigDecimal totalReceivable = receivable.stream()
                .map(ReceivableFee::getReceivableAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        List<ReceivedFee> received = receivedFeeMapper.selectList(
                new LambdaQueryWrapper<ReceivedFee>()
                        .eq(ReceivedFee::getApplicationId, applicationId)
        );
        BigDecimal totalReceived = received.stream()
                .map(ReceivedFee::getReceivedAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        return totalReceived.compareTo(totalReceivable) >= 0;
    }

    public List<ReceivedFee> getReceivedFees(Long applicationId) {
        return receivedFeeMapper.selectList(
                new LambdaQueryWrapper<ReceivedFee>()
                        .eq(ReceivedFee::getApplicationId, applicationId)
        );
    }
}
