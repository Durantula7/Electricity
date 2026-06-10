-- =============================================
-- 小区新装业务管理系统 - 数据库初始化脚本
-- =============================================

-- =============================================
-- 系统管理表
-- =============================================

-- 系统用户
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '电话',
    email VARCHAR(100) COMMENT '邮箱',
    role_id BIGINT COMMENT '角色ID',
    org_name VARCHAR(100) COMMENT '所属单位',
    status TINYINT DEFAULT 1 COMMENT '状态 1正常 0禁用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除'
) COMMENT '系统用户';

-- 角色
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    description VARCHAR(200) COMMENT '描述',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
) COMMENT '角色';

-- 数据字典
DROP TABLE IF EXISTS sys_dict;
CREATE TABLE sys_dict (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dict_type VARCHAR(50) NOT NULL COMMENT '字典类型',
    dict_code VARCHAR(50) NOT NULL COMMENT '字典编码',
    dict_value VARCHAR(100) NOT NULL COMMENT '字典值',
    sort_order INT DEFAULT 0 COMMENT '排序',
    remark VARCHAR(200) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    UNIQUE KEY uk_type_code (dict_type, dict_code)
) COMMENT '数据字典';

-- =============================================
-- 流程主表
-- =============================================

-- 01_004_001 小区新装申请信息
DROP TABLE IF EXISTS application_info;
CREATE TABLE application_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_no VARCHAR(50) NOT NULL UNIQUE COMMENT '申请编号',
    business_type VARCHAR(50) COMMENT '业务类型',
    customer_id BIGINT COMMENT '客户ID',
    customer_name VARCHAR(100) COMMENT '客户名称',
    district VARCHAR(50) COMMENT '行政区',
    electricity_address VARCHAR(200) COMMENT '用电地址',
    contact_person VARCHAR(50) COMMENT '联系人',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    cert_type VARCHAR(20) COMMENT '证件类别',
    cert_no VARCHAR(50) COMMENT '证件号码',
    electricity_category VARCHAR(20) COMMENT '用电类别',
    capacity DECIMAL(12,2) COMMENT '容量(kVA)',
    industry_category VARCHAR(50) COMMENT '行业类别',
    load_nature VARCHAR(20) COMMENT '负荷性质',
    power_supply_unit VARCHAR(100) COMMENT '供电单位',
    household_count INT COMMENT '申请户数',
    remark VARCHAR(500) COMMENT '备注',
    process_status VARCHAR(50) COMMENT '流程状态',
    process_status_name VARCHAR(50) COMMENT '流程状态名称',
    is_intercity TINYINT DEFAULT 0 COMMENT '是否同城异地受理 1是0否',
    intercity_location VARCHAR(100) COMMENT '属地',
    is_high_risk TINYINT DEFAULT 0 COMMENT '是否高风险客户',
    is_dishonest TINYINT DEFAULT 0 COMMENT '是否失信客户',
    accept_user_id BIGINT COMMENT '受理人员ID',
    accept_user_name VARCHAR(50) COMMENT '受理人员',
    accept_time DATETIME COMMENT '受理时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_customer_id (customer_id),
    INDEX idx_process_status (process_status),
    INDEX idx_accept_time (accept_time)
) COMMENT '小区新装申请信息(01_004_001)';

-- 01_099_003 客户资料信息
DROP TABLE IF EXISTS customer_info;
CREATE TABLE customer_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT COMMENT '申请ID',
    customer_name VARCHAR(100) NOT NULL COMMENT '客户名称',
    cert_type VARCHAR(20) COMMENT '证件类别',
    cert_no VARCHAR(50) COMMENT '证件号码',
    legal_representative VARCHAR(50) COMMENT '法定代表人',
    registered_capital VARCHAR(50) COMMENT '注册资本',
    business_scope VARCHAR(200) COMMENT '经营范围',
    address VARCHAR(200) COMMENT '客户地址',
    contact_person VARCHAR(50) COMMENT '联系人',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    post_code VARCHAR(10) COMMENT '邮政编码',
    business_license_no VARCHAR(100) COMMENT '营业执照号',
    organization_code VARCHAR(50) COMMENT '组织机构代码',
    customer_type VARCHAR(20) COMMENT '客户类型',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_cert_no (cert_no)
) COMMENT '客户资料信息(01_099_003)';

-- 01_099_002 用电设备信息
DROP TABLE IF EXISTS electrical_equipment;
CREATE TABLE electrical_equipment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT COMMENT '申请ID',
    equipment_name VARCHAR(100) COMMENT '设备名称',
    equipment_type VARCHAR(50) COMMENT '设备类型',
    quantity INT COMMENT '数量',
    unit_capacity DECIMAL(12,2) COMMENT '单台容量(kW)',
    total_capacity DECIMAL(12,2) COMMENT '总容量(kW)',
    voltage_level VARCHAR(20) COMMENT '电压等级',
    phase_type VARCHAR(10) COMMENT '相数',
    remark VARCHAR(200) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '用电设备信息(01_099_002)';

-- 01_099_032 受电设备方案信息
DROP TABLE IF EXISTS receiving_equipment_plan;
CREATE TABLE receiving_equipment_plan (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT COMMENT '申请ID',
    equipment_name VARCHAR(100) COMMENT '设备名称',
    equipment_type VARCHAR(50) COMMENT '设备类型',
    quantity INT COMMENT '数量',
    unit_capacity DECIMAL(12,2) COMMENT '单台容量(kVA)',
    total_capacity DECIMAL(12,2) COMMENT '总容量(kVA)',
    voltage_level VARCHAR(20) COMMENT '电压等级',
    remark VARCHAR(200) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '受电设备方案信息(01_099_032)';

-- 01_099_044 当前流程信息
DROP TABLE IF EXISTS current_process;
CREATE TABLE current_process (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    current_step VARCHAR(50) NOT NULL COMMENT '当前环节',
    current_step_name VARCHAR(50) COMMENT '当前环节名称',
    current_handler_id BIGINT COMMENT '当前处理人ID',
    current_handler_name VARCHAR(50) COMMENT '当前处理人',
    arrive_time DATETIME COMMENT '到达时间',
    deadline_time DATETIME COMMENT '时限',
    status VARCHAR(20) COMMENT '状态 pending/processing/completed',
    is_overtime TINYINT DEFAULT 0 COMMENT '是否超期',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_handler (current_handler_id),
    INDEX idx_status (status)
) COMMENT '当前流程信息(01_099_044)';

-- 01_099_045 流程记录信息
DROP TABLE IF EXISTS process_record;
CREATE TABLE process_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    process_step VARCHAR(50) NOT NULL COMMENT '流程环节',
    process_step_name VARCHAR(50) COMMENT '流程环节名称',
    operator_id BIGINT COMMENT '操作人ID',
    operator_name VARCHAR(50) COMMENT '操作人',
    operation VARCHAR(50) COMMENT '操作类型 submit/recall/reject/approve',
    operation_comment VARCHAR(500) COMMENT '操作意见',
    arrive_time DATETIME COMMENT '到达时间',
    send_time DATETIME COMMENT '发送时间',
    duration_hours DECIMAL(10,2) COMMENT '处理时长(小时)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_process_step (process_step)
) COMMENT '流程记录信息(01_099_045)';

-- =============================================
-- 各业务环节表
-- =============================================

-- 01_099_047 勘查派工信息
DROP TABLE IF EXISTS survey_dispatch;
CREATE TABLE survey_dispatch (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    dispatch_mode VARCHAR(20) COMMENT '派工方式 single/batch',
    surveyor_id BIGINT COMMENT '勘查人员ID',
    surveyor_name VARCHAR(50) COMMENT '勘查人员',
    dispatcher_id BIGINT COMMENT '派工人员ID',
    dispatcher_name VARCHAR(50) COMMENT '派工人员',
    dispatch_time DATETIME COMMENT '派工时间',
    status VARCHAR(20) COMMENT '状态 dispatched/recalled/pending',
    recall_time DATETIME COMMENT '召回时间',
    recall_reason VARCHAR(200) COMMENT '召回原因',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_surveyor (surveyor_id)
) COMMENT '勘查派工信息(01_099_047)';

-- 01_004_002 小区新装勘查信息
DROP TABLE IF EXISTS survey_info;
CREATE TABLE survey_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    surveyor_id BIGINT COMMENT '勘查员ID',
    surveyor_name VARCHAR(50) COMMENT '勘查员',
    survey_date DATE COMMENT '勘查日期',
    survey_time DATETIME COMMENT '现场勘查时间',
    survey_opinion VARCHAR(500) COMMENT '勘查意见',
    can_supply_power TINYINT COMMENT '是否可供电 1是0否',
    cannot_reason VARCHAR(200) COMMENT '不可供电原因',
    approved_capacity DECIMAL(12,2) COMMENT '核定容量(kVA)',
    power_supply_mode VARCHAR(50) COMMENT '供电方式',
    voltage_level VARCHAR(20) COMMENT '电压等级',
    power_supply_unit VARCHAR(100) COMMENT '供电单位',
    has_project TINYINT COMMENT '是否有工程',
    is_transfer TINYINT COMMENT '是否转供',
    survey_version INT DEFAULT 1 COMMENT '勘查版本',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '小区新装勘查信息(01_004_002)';

-- 01_005_034 供电方案信息
DROP TABLE IF EXISTS power_plan_info;
CREATE TABLE power_plan_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    approved_capacity DECIMAL(12,2) COMMENT '核定容量',
    plan_opinion VARCHAR(500) COMMENT '供电方案拟定意见',
    plan_participants VARCHAR(200) COMMENT '方案拟定参与人',
    plan_date DATE COMMENT '方案拟定日期',
    power_supply_mode VARCHAR(50) COMMENT '供电方式',
    voltage_level VARCHAR(20) COMMENT '电压等级',
    can_supply_power TINYINT COMMENT '是否可供电',
    power_supply_unit VARCHAR(100) COMMENT '供电单位',
    has_project TINYINT COMMENT '是否有工程',
    is_transfer TINYINT COMMENT '是否转供',
    access_system_plan TEXT COMMENT '接入系统方案',
    receiving_system_plan TEXT COMMENT '受电系统方案',
    plan_version INT DEFAULT 1 COMMENT '方案版本',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电方案信息(01_005_034)';

-- 01_099_005 电源方案信息
DROP TABLE IF EXISTS power_source_info;
CREATE TABLE power_source_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT COMMENT '申请ID',
    power_plan_id BIGINT COMMENT '供电方案ID',
    source_nature VARCHAR(20) COMMENT '电源性质（主供/备供）',
    source_type VARCHAR(20) COMMENT '电源类型（单电源/双电源/多电源）',
    operation_mode VARCHAR(50) COMMENT '电源运行方式',
    substation VARCHAR(100) COMMENT '变电站',
    line_name VARCHAR(100) COMMENT '线路',
    supply_voltage VARCHAR(20) COMMENT '供电电压(kV)',
    supply_capacity DECIMAL(12,2) COMMENT '供电容量(kVA)',
    incoming_mode VARCHAR(50) COMMENT '进线方式',
    property_boundary VARCHAR(200) COMMENT '产权分界点',
    incoming_pole_no VARCHAR(50) COMMENT '进线杆号',
    protection_mode VARCHAR(100) COMMENT '保护方式',
    loop_count INT COMMENT '供电回路数',
    line_laying VARCHAR(100) COMMENT '线路敷设方式',
    metering_point VARCHAR(200) COMMENT '考核计量点',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_plan_id (power_plan_id)
) COMMENT '电源方案信息(01_099_005)';

-- 01_099_033 供电方案模板
DROP TABLE IF EXISTS plan_template;
CREATE TABLE plan_template (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_code VARCHAR(50) COMMENT '模板编码',
    capacity_min DECIMAL(12,2) COMMENT '最小容量',
    capacity_max DECIMAL(12,2) COMMENT '最大容量',
    voltage_level VARCHAR(20) COMMENT '电压等级',
    power_supply_mode VARCHAR(50) COMMENT '供电方式',
    template_content TEXT COMMENT '模板内容',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0
) COMMENT '供电方案模板(01_099_033)';

-- 01_099_011 审批信息
DROP TABLE IF EXISTS approval_info;
CREATE TABLE approval_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    approval_level VARCHAR(20) COMMENT '审批级别',
    approver_id BIGINT COMMENT '审批人ID',
    approver_name VARCHAR(50) COMMENT '审批人',
    approval_dept VARCHAR(100) COMMENT '审批部门',
    is_approved TINYINT COMMENT '审批是否同意 1同意0不同意',
    approval_opinion VARCHAR(500) COMMENT '审批意见',
    approval_time DATETIME COMMENT '审批时间',
    approval_mode VARCHAR(20) COMMENT '审批方式 parallel/serial',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_approver (approver_id)
) COMMENT '审批信息(01_099_011)';

-- 01_099_012 供电方案答复信息
DROP TABLE IF EXISTS plan_reply_info;
CREATE TABLE plan_reply_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    reply_person_id BIGINT COMMENT '答复人ID',
    reply_person_name VARCHAR(50) COMMENT '答复人',
    reply_method VARCHAR(20) COMMENT '答复方式',
    reply_date DATE COMMENT '答复日期',
    customer_opinion VARCHAR(500) COMMENT '客户意见',
    customer_signee VARCHAR(50) COMMENT '客户签收人',
    customer_sign_date DATE COMMENT '客户签收日期',
    customer_reply_time DATETIME COMMENT '客户回复时间',
    reply_mode VARCHAR(20) COMMENT '回复方式',
    is_printed TINYINT DEFAULT 0 COMMENT '是否已打印',
    print_time DATETIME COMMENT '打印时间',
    print_person VARCHAR(50) COMMENT '打印人',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电方案答复信息(01_099_012)';

-- 01_099_013 应收业务费
DROP TABLE IF EXISTS receivable_fee;
-- CREATE TABLE receivable_fee (
--     id BIGINT AUTO_INCREMENT PRIMARY KEY,
--     application_id BIGINT NOT NULL COMMENT '申请ID',
--     fee_project VARCHAR(100) NOT NULL COMMENT '收费项目',
--     receivable_amount DECIMAL(12,2) COMMENT '应收金额',
--     fee_determine_time DATETIME COMMENT '费用确定时间',
--     fee_determiner_id BIGINT COMMENT '确定人ID',
--     fee_determiner_name VARCHAR(50) COMMENT '确定人',
--     fee_standard VARCHAR(200) COMMENT '收费标准',
--     is_printed TINYINT DEFAULT 0 COMMENT '是否已打印通知单',
--     primary KEY (id),
--     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--     deleted TINYINT DEFAULT 0,
--     INDEX idx_application_id (application_id)
-- ) COMMENT '应收业务费(01_099_013)';
CREATE TABLE receivable_fee ( 
    id BIGINT AUTO_INCREMENT PRIMARY KEY, 
    application_id BIGINT NOT NULL COMMENT '申请ID', 
    fee_project VARCHAR(100) NOT NULL COMMENT '收费项目', 
    receivable_amount DECIMAL(12,2) COMMENT '应收金额', 
    fee_determine_time DATETIME COMMENT '费用确定时间', 
    fee_determiner_id BIGINT COMMENT '确定人ID', 
    fee_determiner_name VARCHAR(50) COMMENT '确定人', 
    fee_standard VARCHAR(200) COMMENT '收费标准', 
    is_printed TINYINT DEFAULT 0 COMMENT '是否已打印通知单', 
    -- 删除这一行 → primary KEY (id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id) 
) COMMENT '应收业务费(01_099_013)';

-- 01_099_014 实收业务费
DROP TABLE IF EXISTS received_fee;
CREATE TABLE received_fee (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    receivable_fee_id BIGINT COMMENT '应收费用ID',
    fee_project VARCHAR(100) COMMENT '收费项目',
    receivable_amount DECIMAL(12,2) COMMENT '应收金额',
    received_amount DECIMAL(12,2) COMMENT '实收金额',
    unpaid_amount DECIMAL(12,2) COMMENT '未收金额',
    payment_method VARCHAR(20) COMMENT '缴费方式',
    collector_id BIGINT COMMENT '收费人ID',
    collector_name VARCHAR(50) COMMENT '收费人',
    collect_dept VARCHAR(100) COMMENT '收费部门',
    collect_time DATETIME COMMENT '收费时间',
    invoice_no VARCHAR(50) COMMENT '发票号',
    is_printed TINYINT DEFAULT 0 COMMENT '是否已打印凭证',
    check_no VARCHAR(50) COMMENT '支票号',
    check_bank VARCHAR(100) COMMENT '支票银行',
    check_status VARCHAR(20) COMMENT '支票状态',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '实收业务费(01_099_014)';

-- =============================================
-- 供电工程进度跟踪表
-- =============================================

-- 01_099_017 供电工程设计信息
DROP TABLE IF EXISTS project_design_info;
CREATE TABLE project_design_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    project_name VARCHAR(100) COMMENT '工程名称',
    design_unit VARCHAR(100) COMMENT '设计单位',
    design_content TEXT COMMENT '设计内容',
    design_complete_time DATE COMMENT '设计完成时间',
    design_unit_qualification VARCHAR(200) COMMENT '设计单位资质',
    registrar_id BIGINT COMMENT '登记人ID',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程设计信息(01_099_017)';

-- 01_099_019 供电工程设计文件审核结果信息
DROP TABLE IF EXISTS project_design_review;
CREATE TABLE project_design_review (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    submit_unit VARCHAR(100) COMMENT '报送单位',
    submit_person VARCHAR(50) COMMENT '报送人',
    submit_date DATE COMMENT '报送日期',
    receiver VARCHAR(50) COMMENT '接收人',
    reviewer VARCHAR(50) COMMENT '审图人',
    review_date DATE COMMENT '审图日期',
    review_opinion VARCHAR(20) COMMENT '审查意见（同意/不同意）',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程设计文件审核结果(01_099_019)';

-- 01_099_020 供电工程预算结果信息
DROP TABLE IF EXISTS project_budget;
CREATE TABLE project_budget (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    budget_amount DECIMAL(12,2) COMMENT '工程概（预）算费用',
    budget_person VARCHAR(50) COMMENT '概（预）算人',
    budget_date DATE COMMENT '概（预）算日期',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程预算结果(01_099_020)';

-- 01_099_021 供电工程费收取结果信息
DROP TABLE IF EXISTS project_fee_collection;
CREATE TABLE project_fee_collection (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    fee_project VARCHAR(100) COMMENT '收费项目',
    fee_person VARCHAR(50) COMMENT '收费人',
    fee_time DATETIME COMMENT '收费时间',
    received_amount DECIMAL(12,2) COMMENT '实收金额',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程费收取结果(01_099_021)';

-- 01_099_022 供电工程设备供应结果信息
DROP TABLE IF EXISTS project_equipment_supply;
CREATE TABLE project_equipment_supply (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    supply_unit VARCHAR(100) COMMENT '设备供应单位',
    supply_content TEXT COMMENT '供应内容',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程设备供应结果(01_099_022)';

-- 01_099_023 供电工程施工结果信息
DROP TABLE IF EXISTS project_construction;
CREATE TABLE project_construction (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    construction_unit VARCHAR(100) COMMENT '施工单位',
    start_date DATE COMMENT '开工日期',
    completion_date DATE COMMENT '完工日期',
    expected_completion_date DATE COMMENT '预计完工日期',
    is_overtime TINYINT DEFAULT 0 COMMENT '是否超期',
    overtime_reason VARCHAR(200) COMMENT '超期原因',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程施工结果(01_099_023)';

-- 01_099_024 供电工程决算信息
DROP TABLE IF EXISTS project_final_account;
CREATE TABLE project_final_account (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    final_amount DECIMAL(12,2) COMMENT '工程决算费用',
    final_account_person VARCHAR(50) COMMENT '决算人',
    final_account_date DATE COMMENT '决算日期',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程决算信息(01_099_024)';

-- 01_099_800 供电工程质量监督信息
DROP TABLE IF EXISTS project_quality_supervision;
CREATE TABLE project_quality_supervision (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    supervision_unit VARCHAR(100) COMMENT '质量监督单位',
    supervision_result VARCHAR(500) COMMENT '质量监督结果',
    inspector VARCHAR(50) COMMENT '检查人',
    inspection_time DATETIME COMMENT '检查时间',
    quality_rating VARCHAR(20) COMMENT '质量评级结果',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程质量监督信息(01_099_800)';

-- 01_099_015 供电工程监理信息
DROP TABLE IF EXISTS project_supervision;
CREATE TABLE project_supervision (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    supervision_unit VARCHAR(100) COMMENT '监理单位',
    supervisor VARCHAR(50) COMMENT '监理人',
    supervision_content TEXT COMMENT '监理内容',
    start_date DATE COMMENT '监理开始日期',
    end_date DATE COMMENT '监理结束日期',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '供电工程监理信息(01_099_015)';

-- =============================================
-- 其他环节表
-- =============================================

-- 01_099_018 设计文件审核信息
DROP TABLE IF EXISTS design_review_info;
CREATE TABLE design_review_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    design_unit VARCHAR(100) COMMENT '设计单位',
    design_qualification VARCHAR(200) COMMENT '设计资质',
    submit_unit VARCHAR(100) COMMENT '报送单位',
    submit_person VARCHAR(50) COMMENT '报送人',
    submit_date DATE COMMENT '报送日期',
    receiver VARCHAR(50) COMMENT '接收人',
    reviewer VARCHAR(50) COMMENT '审核人',
    review_date DATE COMMENT '审核日期',
    civil_drawings_count INT COMMENT '土建图纸份数',
    line_drawings_count INT COMMENT '线路图纸份数',
    substation_drawings_count INT COMMENT '变电图纸份数',
    review_opinion VARCHAR(20) COMMENT '审查意见（同意/不同意）',
    registrar_name VARCHAR(50) COMMENT '登记人',
    register_time DATETIME COMMENT '登记时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '设计文件审核信息(01_099_018)';

-- 01_099_048 中间检查信息
DROP TABLE IF EXISTS mid_inspection_info;
CREATE TABLE mid_inspection_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    inspector VARCHAR(50) COMMENT '检查人',
    inspection_date DATE COMMENT '检查日期',
    inspection_content VARCHAR(500) COMMENT '检查内容',
    inspection_result VARCHAR(20) COMMENT '检查结果（合格/不合格）',
    defect_description VARCHAR(500) COMMENT '缺陷描述',
    rectification_required TINYINT DEFAULT 0 COMMENT '是否需要整改',
    rectification_deadline DATE COMMENT '整改期限',
    rectification_result VARCHAR(500) COMMENT '整改结果',
    is_printed TINYINT DEFAULT 0 COMMENT '是否已打印',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '中间检查信息(01_099_048)';

-- 01_099_026 报验资料信息
DROP TABLE IF EXISTS completion_apply_info;
CREATE TABLE completion_apply_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    apply_unit VARCHAR(100) COMMENT '报验单位',
    apply_person VARCHAR(50) COMMENT '报验人',
    receiver VARCHAR(50) COMMENT '接收人',
    receive_time DATETIME COMMENT '接收时间',
    apply_requirement VARCHAR(500) COMMENT '报验要求',
    planned_acceptance_time DATETIME COMMENT '计划验收时间',
    apply_version INT DEFAULT 1 COMMENT '报验版本/次数',
    material_complete TINYINT DEFAULT 0 COMMENT '材料是否齐全',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '报验资料信息(01_099_026)';

-- 报验资料意见信息(01_099_027)
DROP TABLE IF EXISTS completion_apply_opinion;
CREATE TABLE completion_apply_opinion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    apply_id BIGINT COMMENT '报验ID',
    opinion_content VARCHAR(500) COMMENT '意见内容',
    opinion_person VARCHAR(50) COMMENT '出具人',
    opinion_time DATETIME COMMENT '出具时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '报验资料意见信息(01_099_027)';

-- 01_099_028 验收通知信息
DROP TABLE IF EXISTS acceptance_notice;
CREATE TABLE acceptance_notice (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    notice_content VARCHAR(500) COMMENT '通知内容',
    notice_person VARCHAR(50) COMMENT '通知人',
    notice_time DATETIME COMMENT '通知时间',
    notice_dept VARCHAR(100) COMMENT '通知部门',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '验收通知信息(01_099_028)';

-- 01_099_029 竣工验收信息
DROP TABLE IF EXISTS completion_check_info;
CREATE TABLE completion_check_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    check_person VARCHAR(50) COMMENT '验收人',
    check_dept VARCHAR(100) COMMENT '验收部门',
    check_time DATETIME COMMENT '验收时间',
    is_qualified TINYINT COMMENT '是否验收合格 1合格0不合格',
    overall_assessment VARCHAR(500) COMMENT '总体评价',
    check_version INT DEFAULT 1 COMMENT '验收版本',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '竣工验收信息(01_099_029)';

-- 01_099_030 验收明细信息
DROP TABLE IF EXISTS completion_check_detail;
CREATE TABLE completion_check_detail (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    check_id BIGINT COMMENT '竣工验收ID',
    check_item VARCHAR(100) COMMENT '验收项目',
    check_standard VARCHAR(200) COMMENT '验收标准',
    check_result VARCHAR(20) COMMENT '验收结果',
    is_qualified TINYINT COMMENT '是否合格',
    remark VARCHAR(200) COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id),
    INDEX idx_check_id (check_id)
) COMMENT '验收明细信息(01_099_030)';

-- 01_099_031 整改通知信息
DROP TABLE IF EXISTS rectification_notice;
CREATE TABLE rectification_notice (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    check_id BIGINT COMMENT '验收ID',
    notice_content VARCHAR(500) COMMENT '整改内容',
    rectification_deadline DATE COMMENT '整改期限',
    issuer VARCHAR(50) COMMENT '发出人',
    issue_time DATETIME COMMENT '发出时间',
    rectification_result VARCHAR(500) COMMENT '整改结果',
    result_confirm_person VARCHAR(50) COMMENT '结果确认人',
    result_confirm_time DATETIME COMMENT '结果确认时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '整改通知信息(01_099_031)';

-- 01_099_010 受电设备信息
DROP TABLE IF EXISTS receiving_equipment;
CREATE TABLE receiving_equipment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    equipment_name VARCHAR(100) COMMENT '设备名称',
    equipment_type VARCHAR(50) COMMENT '设备类型',
    specification VARCHAR(100) COMMENT '规格型号',
    quantity INT COMMENT '数量',
    unit_capacity DECIMAL(12,2) COMMENT '单台容量(kVA)',
    total_capacity DECIMAL(12,2) COMMENT '总容量(kVA)',
    voltage_level VARCHAR(20) COMMENT '电压等级',
    manufacturer VARCHAR(100) COMMENT '生产厂家',
    installation_location VARCHAR(200) COMMENT '安装位置',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '受电设备信息(01_099_010)';

-- 01_099_042 业务资料归档信息
DROP TABLE IF EXISTS archive_info;
CREATE TABLE archive_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    archive_no VARCHAR(50) COMMENT '档案号',
    archive_location VARCHAR(200) COMMENT '档案存放位置',
    archiver_id BIGINT COMMENT '归档人ID',
    archiver_name VARCHAR(50) COMMENT '归档人',
    archive_time DATETIME COMMENT '归档时间',
    material_list TEXT COMMENT '归档材料清单',
    is_complete TINYINT DEFAULT 0 COMMENT '资料是否完整',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    UNIQUE KEY uk_application_id (application_id)
) COMMENT '业务资料归档信息(01_099_042)';

-- =============================================
-- 低压批量用户表
-- =============================================
DROP TABLE IF EXISTS batch_household;
CREATE TABLE batch_household (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    application_id BIGINT NOT NULL COMMENT '申请ID',
    household_name VARCHAR(100) COMMENT '户名',
    electricity_address VARCHAR(200) COMMENT '用电地址',
    electricity_category VARCHAR(20) COMMENT '用电类别',
    capacity DECIMAL(12,2) COMMENT '容量(kVA)',
    customer_type VARCHAR(20) COMMENT '客户类型',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT DEFAULT 0,
    INDEX idx_application_id (application_id)
) COMMENT '低压批量用户明细';
