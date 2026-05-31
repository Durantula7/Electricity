package com.electricity.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("archive_info")
public class ArchiveInfo extends BaseEntity {
    private Long applicationId;
    private String archiveNo;
    private String archiveLocation;
    private Long archiverId;
    private String archiverName;
    private LocalDateTime archiveTime;
    private String materialList;
    private Integer isComplete;
}
