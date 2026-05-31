package com.electricity.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.electricity.common.PageResult;
import com.electricity.entity.*;
import com.electricity.mapper.*;
import com.electricity.service.workflow.WorkflowEngine;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ArchiveService {
    private final ArchiveInfoMapper archiveInfoMapper;
    private final ApplicationInfoMapper applicationInfoMapper;
    private final WorkflowEngine workflowEngine;

    public PageResult<ApplicationInfo> listPendingArchive(Integer pageNum, Integer pageSize) {
        Page<ApplicationInfo> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ApplicationInfo> wrapper = new LambdaQueryWrapper<ApplicationInfo>()
                .eq(ApplicationInfo::getProcessStatus, "INFO_ARCHIVE")
                .orderByAsc(ApplicationInfo::getAcceptTime);
        Page<ApplicationInfo> result = applicationInfoMapper.selectPage(page, wrapper);
        return PageResult.of(result.getTotal(), result.getCurrent(), result.getSize(), result.getRecords());
    }

    @Transactional
    public void archive(Long applicationId, ArchiveInfo archiveInfo,
                        Long operatorId, String operatorName) {
        archiveInfo.setApplicationId(applicationId);
        archiveInfo.setArchiverId(operatorId);
        archiveInfo.setArchiverName(operatorName);
        archiveInfoMapper.insert(archiveInfo);
        workflowEngine.submitToNext(applicationId, operatorId, operatorName, "归档完成", false, false);
    }
}
