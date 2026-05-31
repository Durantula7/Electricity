-- =============================================
-- 初始数据
-- =============================================

-- 角色
INSERT IGNORE INTO sys_role (id, role_code, role_name, description) VALUES
(1, 'ADMIN', '系统管理员', '系统管理权限'),
(2, 'ACCEPT_STAFF', '受理人员', '业务受理'),
(3, 'DISPATCH_STAFF', '勘查派工人员', '勘查派工'),
(4, 'SURVEYOR', '勘查人员', '现场勘查'),
(5, 'PLAN_DRAFTER', '方案拟定人员', '拟定供电方案'),
(6, 'APPROVER', '审批人员', '方案审批'),
(7, 'REPLY_STAFF', '答复人员', '答复供电方案'),
(8, 'FEE_DETERMINER', '费用确定人员', '确定费用'),
(9, 'CASHIER', '收费人员', '业务收费'),
(10, 'PROJECT_MANAGER', '工程管理人员', '供电工程进度跟踪'),
(11, 'DESIGN_REVIEWER', '设计审核人员', '设计文件审核'),
(12, 'INSPECTOR', '中间检查人员', '中间检查'),
(13, 'ACCEPTANCE_STAFF', '验收人员', '竣工验收'),
(14, 'ARCHIVER', '归档人员', '资料归档');

-- 用户 (密码均为 123456 的 BCrypt 加密)
INSERT IGNORE INTO sys_user (id, username, password, real_name, role_id, org_name, status) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5Eh', '系统管理员', 1, '供电公司', 1),
(2, 'acceptor', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '受理员张三', 2, '供电营业厅', 1),
(3, 'dispatcher', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '派工员李四', 3, '供电营业厅', 1),
(4, 'surveyor', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '勘查员王五', 4, '运维检修部', 1),
(5, 'planner', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '方案员赵六', 5, '营销部', 1),
(6, 'approver', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '审批员钱七', 6, '营销部', 1),
(7, 'replier', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '答复员孙八', 7, '供电营业厅', 1),
(8, 'fee_determiner', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '费用员周九', 8, '营销部', 1),
(9, 'cashier', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '收费员吴十', 9, '财务部', 1),
(10, 'proj_mgr', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '工程管理员郑一', 10, '运维检修部', 1),
(11, 'design_reviewer', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '设计审核员陈二', 11, '营销部', 1),
(12, 'inspector', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '检查员刘三', 12, '运维检修部', 1),
(13, 'checker', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '验收员黄四', 13, '营销部', 1),
(14, 'archiver', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iK9Lq8Ws', '归档员林五', 14, '营销部', 1);

-- 数据字典
INSERT IGNORE INTO sys_dict (dict_type, dict_code, dict_value, sort_order) VALUES
-- 用电类别
('electricity_category', 'L1', '居民生活用电', 1),
('electricity_category', 'L2', '一般工商业用电', 2),
('electricity_category', 'L3', '大工业用电', 3),
('electricity_category', 'L4', '农业生产用电', 4),
-- 负荷性质
('load_nature', 'IMPORTANT', '重要负荷', 1),
('load_nature', 'NORMAL', '普通负荷', 2),
('load_nature', 'SECURITY', '保安负荷', 3),
-- 证件类别
('cert_type', 'ID_CARD', '身份证', 1),
('cert_type', 'BUSINESS_LICENSE', '营业执照', 2),
('cert_type', 'ORG_CODE', '组织机构代码证', 3),
-- 供电方式
('power_supply_mode', 'HIGH_SINGLE', '高压单电源', 1),
('power_supply_mode', 'HIGH_DUAL', '高压双电源', 2),
('power_supply_mode', 'HIGH_MULTI', '高压多电源', 3),
('power_supply_mode', 'LOW_SINGLE', '低压单电源', 4),
-- 电压等级
('voltage_level', '0.4kV', '0.4kV', 1),
('voltage_level', '10kV', '10kV', 2),
('voltage_level', '35kV', '35kV', 3),
('voltage_level', '110kV', '110kV', 4),
-- 流程状态
('process_status', 'BUSINESS_ACCEPTANCE', '业务受理', 1),
('process_status', 'SURVEY_DISPATCH', '勘查派工', 2),
('process_status', 'FIELD_SURVEY', '现场勘查', 3),
('process_status', 'PLAN_DRAFT', '拟定供电方案', 4),
('process_status', 'APPROVAL', '审批', 5),
('process_status', 'PLAN_REPLY', '答复供电方案', 6),
('process_status', 'FEE_DETERMINE', '确定费用', 7),
('process_status', 'FEE_COLLECTION', '业务收费', 8),
('process_status', 'PROJECT_TRACKING', '供电工程进度跟踪', 9),
('process_status', 'DESIGN_REVIEW', '设计文件审核', 10),
('process_status', 'MID_INSPECTION', '中间检查', 11),
('process_status', 'COMPLETION_APPLY', '竣工报验', 12),
('process_status', 'COMPLETION_CHECK', '竣工验收', 13),
('process_status', 'INFO_ARCHIVE', '信息归档', 14),
('process_status', 'ARCHIVE', '归档', 15),
('process_status', 'FINISHED', '已办结', 16),
-- 电源性质
('source_nature', 'MAIN', '主供', 1),
('source_nature', 'STANDBY', '备供', 2),
-- 电源类型
('source_type', 'SINGLE', '单电源', 1),
('source_type', 'DUAL', '双电源', 2),
('source_type', 'MULTI', '多电源', 3),
-- 进线方式
('incoming_mode', 'OVERHEAD', '架空进线', 1),
('incoming_mode', 'CABLE', '电缆进线', 2),
('incoming_mode', 'MIXED', '混合进线', 3),
-- 审批方式
('approval_mode', 'SERIAL', '串行审批', 1),
('approval_mode', 'PARALLEL', '并行审批', 2),
-- 业务类型
('business_type', 'NEW_INSTALL', '小区新装', 1);


INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(1, 'SQ20260115001', 'NEW_INSTALL', '碧桂园翡翠湾置业有限公司', '朝阳区', '朝阳区东风南路88号碧桂园翡翠湾', '陈建国', '13801001234', 'BUSINESS_LICENSE', '91110105MA00XXXXX1', 'L1', 8000.00, 'RESIDENTIAL', 'NORMAL', '国网朝阳供电公司', 1200, '新建高层住宅小区，共8栋楼，1200户', 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', '2026-01-15 09:30:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(1, '碧桂园翡翠湾置业有限公司', 'BUSINESS_LICENSE', '91110105MA00XXXXX1', '陈建国', '朝阳区东风南路88号', '陈建国', '13801001234', '91110105MA00XXXXX1', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(1, '居民用电总负荷', '照明及家电', 1200, 5.00, 6000.00, '0.4kV', '三相'),
(1, '公共设施用电', '电梯水泵消防', 1, 2000.00, 2000.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(1, 'BUSINESS_ACCEPTANCE', '业务受理', 'processing', '2026-01-15 09:30:00');

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(1, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '客户到营业厅提交申请，资料齐全，已受理', '2026-01-15 09:30:00', '2026-01-15 09:30:00');

-- ============================================
-- 2. 万科金色家园 - 勘查派工阶段
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(2, 'SQ20260220001', 'NEW_INSTALL', '万科金色家园房地产开发有限公司', '海淀区', '海淀区中关村南大街56号万科金色家园', '刘芳', '13901002345', 'BUSINESS_LICENSE', '91110108MA00XXXXX2', 'L1', 6500.00, 'RESIDENTIAL', 'NORMAL', '国网海淀供电公司', 950, '新建高层住宅小区，共6栋楼，950户', 'SURVEY_DISPATCH', '勘查派工', 2, '受理员张三', '2026-02-20 14:00:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(2, '万科金色家园房地产开发有限公司', 'BUSINESS_LICENSE', '91110108MA00XXXXX2', '刘芳', '海淀区中关村南大街56号', '刘芳', '13901002345', '91110108MA00XXXXX2', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(2, '居民用电总负荷', '照明及家电', 950, 5.00, 4750.00, '0.4kV', '三相'),
(2, '公共设施用电', '电梯水泵消防', 1, 1750.00, 1750.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(2, 'SURVEY_DISPATCH', '勘查派工', 'processing', '2026-02-21 08:30:00');

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(2, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '客户来电咨询后到厅提交申请', '2026-02-20 14:00:00', '2026-02-20 14:00:00'),
(2, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '资料审核通过，提交勘查派工', '2026-02-20 14:00:00', '2026-02-21 08:30:00');

-- ============================================
-- 3. 绿地世纪城 - 现场勘查阶段
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(3, 'SQ20260310001', 'NEW_INSTALL', '绿地世纪城置业有限公司', '大兴区', '大兴区黄村镇兴华大街100号绿地世纪城', '王强', '13701003456', 'BUSINESS_LICENSE', '91110115MA00XXXXX3', 'L2', 12000.00, 'MIXED', 'IMPORTANT', '国网大兴供电公司', 1800, '商住混合大型社区，含商业综合体，共12栋楼，1800户', 'FIELD_SURVEY', '现场勘查', 2, '受理员张三', '2026-03-10 10:00:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(3, '绿地世纪城置业有限公司', 'BUSINESS_LICENSE', '91110115MA00XXXXX3', '王强', '大兴区黄村镇兴华大街100号', '王强', '13701003456', '91110115MA00XXXXX3', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(3, '居民用电总负荷', '照明及家电', 1800, 5.00, 9000.00, '0.4kV', '三相'),
(3, '商业用电负荷', '商业照明空调', 1, 2000.00, 2000.00, '10kV', '三相'),
(3, '公共设施用电', '电梯水泵消防', 1, 1000.00, 1000.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(3, 'FIELD_SURVEY', '现场勘查', 'processing', '2026-03-13 09:00:00');

INSERT IGNORE INTO survey_dispatch (application_id, dispatch_mode, surveyor_id, surveyor_name, dispatcher_id, dispatcher_name, dispatch_time, status) VALUES
(3, 'single', 4, '勘查员王五', 3, '派工员李四', '2026-03-13 08:50:00', 'dispatched');

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(3, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '客户网上预约后到厅办理', '2026-03-10 10:00:00', '2026-03-10 10:00:00'),
(3, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '提交勘查派工', '2026-03-10 10:00:00', '2026-03-12 16:00:00'),
(3, 'SURVEY_DISPATCH', '勘查派工', 3, '派工员李四', 'submit', '已指派勘查员王五到现场勘查', '2026-03-12 16:00:00', '2026-03-13 08:50:00');

-- ============================================
-- 4. 恒大绿洲 - 拟定供电方案阶段
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(4, 'SQ20260325001', 'NEW_INSTALL', '恒大绿洲房地产开发有限公司', '通州区', '通州区梨园镇九棵树东路200号恒大绿洲', '张伟', '13601004567', 'BUSINESS_LICENSE', '91110112MA00XXXXX4', 'L1', 9500.00, 'RESIDENTIAL', 'NORMAL', '国网通州供电公司', 1500, '大型住宅社区，共10栋楼，1500户。现场勘查已完成，具备供电条件', 'PLAN_DRAFT', '拟定供电方案', 2, '受理员张三', '2026-03-25 11:00:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(4, '恒大绿洲房地产开发有限公司', 'BUSINESS_LICENSE', '91110112MA00XXXXX4', '张伟', '通州区梨园镇九棵树东路200号', '张伟', '13601004567', '91110112MA00XXXXX4', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(4, '居民用电总负荷', '照明及家电', 1500, 5.00, 7500.00, '0.4kV', '三相'),
(4, '公共设施用电', '电梯水泵消防', 1, 2000.00, 2000.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(4, 'PLAN_DRAFT', '拟定供电方案', 'processing', '2026-04-02 09:00:00');

INSERT IGNORE INTO survey_dispatch (application_id, dispatch_mode, surveyor_id, surveyor_name, dispatcher_id, dispatcher_name, dispatch_time, status) VALUES
(4, 'single', 4, '勘查员王五', 3, '派工员李四', '2026-03-28 09:00:00', 'dispatched');

INSERT IGNORE INTO survey_info (application_id, surveyor_id, surveyor_name, survey_date, survey_time, survey_opinion, can_supply_power, approved_capacity, power_supply_mode, voltage_level, power_supply_unit, has_project, is_transfer, survey_version) VALUES
(4, 4, '勘查员王五', '2026-03-30', '2026-03-30 10:00:00', '现场勘查确认该小区具备供电条件。建议从110kV梨园变电站新出10kV专线供电，采用高压单电源供电方式。小区内设置10kV开闭所一座，配电变压器12台。', 1, 9500.00, 'HIGH_SINGLE', '10kV', '国网通州供电公司', 1, 0, 1);

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(4, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '客户到厅提交完整资料', '2026-03-25 11:00:00', '2026-03-25 11:00:00'),
(4, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '提交勘查派工', '2026-03-25 11:00:00', '2026-03-28 09:00:00'),
(4, 'SURVEY_DISPATCH', '勘查派工', 3, '派工员李四', 'submit', '派工完成', '2026-03-28 09:00:00', '2026-03-28 09:00:00'),
(4, 'FIELD_SURVEY', '现场勘查', 4, '勘查员王五', 'submit', '现场勘查完成，具备供电条件，建议10kV专线供电', '2026-03-28 09:00:00', '2026-04-01 16:30:00');

-- ============================================
-- 5. 保利天悦 - 审批阶段
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(5, 'SQ20260415001', 'NEW_INSTALL', '保利天悦置业有限公司', '丰台区', '丰台区科技园南路300号保利天悦', '赵敏', '13501005678', 'BUSINESS_LICENSE', '91110106MA00XXXXX5', 'L1', 7200.00, 'RESIDENTIAL', 'NORMAL', '国网丰台供电公司', 1100, '精品住宅小区，共7栋楼，1100户。供电方案已拟定完成，待审批', 'APPROVAL', '审批', 2, '受理员张三', '2026-04-15 09:00:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(5, '保利天悦置业有限公司', 'BUSINESS_LICENSE', '91110106MA00XXXXX5', '赵敏', '丰台区科技园南路300号', '赵敏', '13501005678', '91110106MA00XXXXX5', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(5, '居民用电总负荷', '照明及家电', 1100, 5.00, 5500.00, '0.4kV', '三相'),
(5, '公共设施用电', '电梯水泵消防', 1, 1700.00, 1700.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(5, 'APPROVAL', '审批', 'processing', '2026-04-22 09:00:00');

INSERT IGNORE INTO survey_dispatch (application_id, dispatch_mode, surveyor_id, surveyor_name, dispatcher_id, dispatcher_name, dispatch_time, status) VALUES
(5, 'single', 4, '勘查员王五', 3, '派工员李四', '2026-04-17 09:00:00', 'dispatched');

INSERT IGNORE INTO survey_info (application_id, surveyor_id, surveyor_name, survey_date, survey_time, survey_opinion, can_supply_power, approved_capacity, power_supply_mode, voltage_level, power_supply_unit, has_project, is_transfer, survey_version) VALUES
(5, 4, '勘查员王五', '2026-04-18', '2026-04-18 14:00:00', '经现场勘查，该小区位于丰台科技园内，周边供电设施完善。建议从110kV科技园变电站新出10kV线路供电。', 1, 7200.00, 'HIGH_SINGLE', '10kV', '国网丰台供电公司', 1, 0, 1);

INSERT IGNORE INTO power_plan_info (application_id, approved_capacity, plan_opinion, plan_participants, plan_date, power_supply_mode, voltage_level, can_supply_power, power_supply_unit, has_project, is_transfer, access_system_plan, receiving_system_plan, plan_version) VALUES
(5, 7200.00, '同意勘查意见。采用10kV高压单电源供电，从110kV科技园变电站新出10kV电缆线路至小区开闭所。小区内设置10kV开闭所1座，配电变压器10台（800kVA×8+630kVA×2），总容量7660kVA。', '方案员赵六、勘查员王五、主任工程师李明', '2026-04-20', 'HIGH_SINGLE', '10kV', 1, '国网丰台供电公司', 1, 0, '供电电压：10kV；供电容量：7200kVA；供电电源：110kV科技园变电站；出线方式：10kV电缆；供电回路：单回路；线路路径：由变电站沿科技园南路向东至小区红线，全长约1.2km。', '进线方式：电缆进线；受电装置容量：7660kVA（10台变压器）；主接线方式：单母线分段；运行方式：主供运行；继电保护：微机保护；计量方式：高供高计，考核计量点设在开闭所进线侧。', 1);

INSERT IGNORE INTO power_source_info (application_id, power_plan_id, source_nature, source_type, operation_mode, substation, line_name, supply_voltage, supply_capacity, incoming_mode, property_boundary, incoming_pole_no, protection_mode) VALUES
(5, 1, 'MAIN', 'SINGLE', '主供运行', '110kV科技园变电站', '10kV科技园南路一线', '10kV', 7200.00, 'CABLE', '小区红线外1米处10kV电缆分支箱', 'N/A', '微机综合保护');

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(5, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '客户提交完整申请资料', '2026-04-15 09:00:00', '2026-04-15 09:00:00'),
(5, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '提交', '2026-04-15 09:00:00', '2026-04-17 09:00:00'),
(5, 'SURVEY_DISPATCH', '勘查派工', 3, '派工员李四', 'submit', '派工', '2026-04-17 09:00:00', '2026-04-17 09:00:00'),
(5, 'FIELD_SURVEY', '现场勘查', 4, '勘查员王五', 'submit', '现场勘查完成，供电条件良好', '2026-04-17 09:00:00', '2026-04-19 15:00:00'),
(5, 'PLAN_DRAFT', '拟定供电方案', 5, '方案员赵六', 'submit', '供电方案拟定完成，提交审批', '2026-04-19 15:00:00', '2026-04-22 09:00:00');

-- ============================================
-- 6. 华润万象城 - 业务收费阶段 (大型商住综合体，已完成审批答复)
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(6, 'SQ20260508001', 'NEW_INSTALL', '华润万象城置业有限公司', '西城区', '西城区金融街延长线88号华润万象城', '周明', '13301006789', 'BUSINESS_LICENSE', '91110102MA00XXXXX6', 'L2', 18000.00, 'MIXED', 'IMPORTANT', '国网西城供电公司', 2200, '大型城市综合体，含住宅、商业、写字楼。已审批通过，费用已确定，待收费', 'FEE_COLLECTION', '业务收费', 2, '受理员张三', '2026-05-08 08:30:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(6, '华润万象城置业有限公司', 'BUSINESS_LICENSE', '91110102MA00XXXXX6', '周明', '西城区金融街延长线88号', '周明', '13301006789', '91110102MA00XXXXX6', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(6, '住宅用电总负荷', '照明及家电', 2200, 5.00, 11000.00, '0.4kV', '三相'),
(6, '商业用电负荷', '商业照明空调动力', 1, 5000.00, 5000.00, '10kV', '三相'),
(6, '写字楼用电负荷', '办公照明空调', 1, 2000.00, 2000.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(6, 'FEE_COLLECTION', '业务收费', 'processing', '2026-05-20 09:00:00');

INSERT IGNORE INTO survey_dispatch (application_id, dispatch_mode, surveyor_id, surveyor_name, dispatcher_id, dispatcher_name, dispatch_time, status) VALUES
(6, 'single', 4, '勘查员王五', 3, '派工员李四', '2026-05-10 09:00:00', 'dispatched');

INSERT IGNORE INTO survey_info (application_id, surveyor_id, surveyor_name, survey_date, survey_time, survey_opinion, can_supply_power, approved_capacity, power_supply_mode, voltage_level, power_supply_unit, has_project, is_transfer, survey_version) VALUES
(6, 4, '勘查员王五', '2026-05-12', '2026-05-12 09:00:00', '该大型综合体项目位于西城区核心地段，周边电网完善。因用电容量大且含重要商业负荷，建议采用10kV高压双电源供电，提高供电可靠性。', 1, 18000.00, 'HIGH_DUAL', '10kV', '国网西城供电公司', 1, 0, 1);

INSERT IGNORE INTO power_plan_info (application_id, approved_capacity, plan_opinion, plan_participants, plan_date, power_supply_mode, voltage_level, can_supply_power, power_supply_unit, has_project, is_transfer, access_system_plan, receiving_system_plan, plan_version) VALUES
(6, 18000.00, '同意采用10kV双电源供电方案，主供电源从110kV金融街变电站接入，备供电源从110kV西直门变电站接入。设置10kV开闭所1座，配电变压器18台。', '方案员赵六、主任工程师李明', '2026-05-14', 'HIGH_DUAL', '10kV', 1, '国网西城供电公司', 1, 0, '供电电压：10kV；供电容量：18000kVA；主供电源：110kV金融街变电站；备供电源：110kV西直门变电站；供电回路：双回路；线路敷设：10kV电缆沿市政管沟敷设。', '进线方式：电缆进线；受电装置容量：20000kVA（18台变压器）；主接线方式：单母线分段加联络；运行方式：两路电源同时运行、互为备用；计量方式：高供高计。', 1);

INSERT IGNORE INTO power_source_info (application_id, power_plan_id, source_nature, source_type, operation_mode, substation, line_name, supply_voltage, supply_capacity, incoming_mode, property_boundary, protection_mode) VALUES
(6, 1, 'MAIN', 'DUAL', '主供运行', '110kV金融街变电站', '10kV金融街一线', '10kV', 18000.00, 'CABLE', '小区红线外1米处10kV电缆分支箱', '微机综合保护'),
(6, 1, 'STANDBY', 'DUAL', '备用自投', '110kV西直门变电站', '10kV西直门二线', '10kV', 18000.00, 'CABLE', '小区红线外1米处10kV电缆分支箱', '微机综合保护');

INSERT IGNORE INTO approval_info (application_id, approval_level, approver_id, approver_name, approval_dept, is_approved, approval_opinion, approval_time, approval_mode) VALUES
(6, '1', 6, '审批员钱七', '营销部', 1, '供电方案合理，符合配网规划，同意该方案。', '2026-05-16 10:30:00', 'SERIAL');

INSERT IGNORE INTO plan_reply_info (application_id, reply_person_id, reply_person_name, reply_method, reply_date, customer_opinion, customer_signee, customer_sign_date, customer_reply_time, reply_mode) VALUES
(6, 7, '答复员孙八', 'WRITTEN', '2026-05-18', '无异议，同意供电方案', '周明', '2026-05-18', '2026-05-18 15:00:00', 'WRITTEN');

INSERT IGNORE INTO receivable_fee (id, application_id, fee_project, receivable_amount, fee_determine_time, fee_determiner_id, fee_determiner_name, fee_standard) VALUES
(1, 6, '高可靠性供电费', 360000.00, '2026-05-19 10:00:00', 8, '费用员周九', '按容量360元/kVA（双电源）'),
(2, 6, '配套费', 270000.00, '2026-05-19 10:00:00', 8, '费用员周九', '按面积150元/平方米');

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(6, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '受理大型综合体用电申请', '2026-05-08 08:30:00', '2026-05-08 08:30:00'),
(6, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '提交勘查派工', '2026-05-08 08:30:00', '2026-05-10 09:00:00'),
(6, 'SURVEY_DISPATCH', '勘查派工', 3, '派工员李四', 'submit', '派工', '2026-05-10 09:00:00', '2026-05-10 09:00:00'),
(6, 'FIELD_SURVEY', '现场勘查', 4, '勘查员王五', 'submit', '勘查完成，建议双电源', '2026-05-10 09:00:00', '2026-05-13 16:00:00'),
(6, 'PLAN_DRAFT', '拟定供电方案', 5, '方案员赵六', 'submit', '双电源方案拟定完成', '2026-05-13 16:00:00', '2026-05-15 10:00:00'),
(6, 'APPROVAL', '审批', 6, '审批员钱七', 'approve', '审批通过', '2026-05-15 10:00:00', '2026-05-16 10:30:00'),
(6, 'PLAN_REPLY', '答复供电方案', 7, '答复员孙八', 'submit', '书面答复客户，客户无异议', '2026-05-16 10:30:00', '2026-05-18 15:00:00'),
(6, 'FEE_DETERMINE', '确定费用', 8, '费用员周九', 'submit', '费用已确定，通知客户缴费', '2026-05-18 15:00:00', '2026-05-20 09:00:00');

-- ============================================
-- 7. 融创滨江壹号 - 已办结 (完整走完流程)
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(7, 'SQ20260105001', 'NEW_INSTALL', '融创滨江壹号置业有限公司', '昌平区', '昌平区回龙观镇滨江路66号融创滨江壹号', '孙丽', '13101007890', 'BUSINESS_LICENSE', '91110114MA00XXXXX7', 'L1', 5500.00, 'RESIDENTIAL', 'NORMAL', '国网昌平供电公司', 800, '中高端住宅小区，共5栋楼，800户。2026年1月受理，已完整走完流程归档', 'FINISHED', '已办结', 2, '受理员张三', '2026-01-05 10:00:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(7, '融创滨江壹号置业有限公司', 'BUSINESS_LICENSE', '91110114MA00XXXXX7', '孙丽', '昌平区回龙观镇滨江路66号', '孙丽', '13101007890', '91110114MA00XXXXX7', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(7, '居民用电总负荷', '照明及家电', 800, 5.00, 4000.00, '0.4kV', '三相'),
(7, '公共设施用电', '电梯水泵消防', 1, 1500.00, 1500.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(7, 'FINISHED', '已办结', 'completed', '2026-05-25 10:00:00');

INSERT IGNORE INTO survey_dispatch (application_id, dispatch_mode, surveyor_id, surveyor_name, dispatcher_id, dispatcher_name, dispatch_time, status) VALUES
(7, 'single', 4, '勘查员王五', 3, '派工员李四', '2026-01-08 09:00:00', 'dispatched');

INSERT IGNORE INTO survey_info (application_id, surveyor_id, surveyor_name, survey_date, survey_time, survey_opinion, can_supply_power, approved_capacity, power_supply_mode, voltage_level, power_supply_unit, has_project, is_transfer, survey_version) VALUES
(7, 4, '勘查员王五', '2026-01-10', '2026-01-10 10:00:00', '经现场勘查，具备供电条件。建议从110kV回龙观变电站新出10kV线路供电。', 1, 5500.00, 'HIGH_SINGLE', '10kV', '国网昌平供电公司', 1, 0, 1);

INSERT IGNORE INTO power_plan_info (application_id, approved_capacity, plan_opinion, plan_participants, plan_date, power_supply_mode, voltage_level, can_supply_power, power_supply_unit, has_project, is_transfer, access_system_plan, receiving_system_plan, plan_version) VALUES
(7, 5500.00, '同意10kV单电源供电方案。从110kV回龙观变电站新出10kV电缆至小区开闭所，设变压器8台。', '方案员赵六', '2026-01-12', 'HIGH_SINGLE', '10kV', 1, '国网昌平供电公司', 1, 0, '10kV单电源供电，从110kV回龙观变电站电缆出线', '电缆进线，8台变压器，单母线接线', 1);

INSERT IGNORE INTO power_source_info (application_id, power_plan_id, source_nature, source_type, operation_mode, substation, line_name, supply_voltage, supply_capacity, incoming_mode, property_boundary, protection_mode) VALUES
(7, 1, 'MAIN', 'SINGLE', '主供运行', '110kV回龙观变电站', '10kV滨江线', '10kV', 5500.00, 'CABLE', '小区红线外1米', '微机保护');

INSERT IGNORE INTO approval_info (application_id, approval_level, approver_id, approver_name, approval_dept, is_approved, approval_opinion, approval_time, approval_mode) VALUES
(7, '1', 6, '审批员钱七', '营销部', 1, '方案符合要求，同意。', '2026-01-14 09:30:00', 'SERIAL');

INSERT IGNORE INTO plan_reply_info (application_id, reply_person_id, reply_person_name, reply_method, reply_date, customer_opinion, customer_signee, customer_sign_date, customer_reply_time, reply_mode) VALUES
(7, 7, '答复员孙八', 'WRITTEN', '2026-01-16', '同意方案', '孙丽', '2026-01-16', '2026-01-16 14:00:00', 'WRITTEN');

INSERT IGNORE INTO receivable_fee (id, application_id, fee_project, receivable_amount, fee_determine_time, fee_determiner_id, fee_determiner_name, fee_standard) VALUES
(3, 7, '配套费', 120000.00, '2026-01-18 09:00:00', 8, '费用员周九', '按面积150元/平方米');

INSERT IGNORE INTO received_fee (application_id, receivable_fee_id, fee_project, receivable_amount, received_amount, unpaid_amount, payment_method, collector_id, collector_name, collect_dept, collect_time, invoice_no) VALUES
(7, 3, '配套费', 120000.00, 120000.00, 0.00, 'BANK', 9, '收费员吴十', '财务部', '2026-01-20 14:00:00', 'INV20260120001');

INSERT IGNORE INTO design_review_info (application_id, design_unit, design_qualification, submit_unit, submit_person, submit_date, receiver, reviewer, review_date, review_opinion, registrar_name, register_time) VALUES
(7, '北京电力设计院', '甲级电力设计资质', '融创滨江壹号置业有限公司', '孙丽', '2026-02-01', '设计审核员陈二', '设计审核员陈二', '2026-02-15', '同意', '设计审核员陈二', '2026-02-15 16:00:00');

INSERT IGNORE INTO mid_inspection_info (application_id, inspector, inspection_date, inspection_content, inspection_result, rectification_required, is_printed) VALUES
(7, '检查员刘三', '2026-03-20', '检查10kV电缆敷设、开闭所土建、变压器基础等隐蔽工程施工质量', '合格', 0, 1);

INSERT IGNORE INTO completion_apply_info (application_id, apply_unit, apply_person, receive_time, apply_requirement, planned_acceptance_time, apply_version, material_complete) VALUES
(7, '融创滨江壹号项目部', '孙丽', '2026-05-10 09:00:00', '申请对融创滨江壹号10kV配电工程进行竣工验收，工程已按设计图纸全部完成', '2026-05-15 09:00:00', 1, 1);

INSERT IGNORE INTO completion_check_info (application_id, check_person, check_dept, check_time, is_qualified, overall_assessment, check_version) VALUES
(7, '验收员黄四', '营销部', '2026-05-15 10:00:00', 1, '工程质量符合设计和规范要求，电气设备安装规范，保护调试合格，同意投运。', 1);

INSERT IGNORE INTO completion_check_detail (application_id, check_id, check_item, check_standard, check_result, is_qualified) VALUES
(7, 1, '资质验收', '检查施工、设计、监理单位资质', '合格', 1),
(7, 1, '资料验收', '检查竣工图纸、试验报告等资料完整性', '合格', 1),
(7, 1, '安装质量验收', '按GB50150验收电气设备安装质量', '合格', 1);

INSERT IGNORE INTO receiving_equipment (application_id, equipment_name, equipment_type, specification, quantity, unit_capacity, total_capacity, voltage_level, manufacturer, installation_location) VALUES
(7, '干式变压器', 'SCB13-800/10', '800kVA 10/0.4kV', 6, 800.00, 4800.00, '10kV', '特变电工', '1#-6#配电室'),
(7, '干式变压器', 'SCB13-630/10', '630kVA 10/0.4kV', 2, 630.00, 1260.00, '10kV', '特变电工', '7#-8#配电室'),
(7, '高压开关柜', 'KYN28A-12', '12kV 630A', 16, NULL, NULL, '10kV', '正泰电气', '开闭所及配电室');

INSERT IGNORE INTO archive_info (application_id, archive_no, archive_location, archiver_id, archiver_name, archive_time, material_list, is_complete) VALUES
(7, 'DA20260525001', '档案室A区3排5层', 14, '归档员林五', '2026-05-25 10:00:00', '用电申请书、营业执照复印件、勘查工作单、供电方案答复单、竣工图纸、验收单、中间检查记录', 1);

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(7, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '受理融创滨江壹号用电申请', '2026-01-05 10:00:00', '2026-01-05 10:00:00'),
(7, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '提交', '2026-01-05 10:00:00', '2026-01-08 08:30:00'),
(7, 'SURVEY_DISPATCH', '勘查派工', 3, '派工员李四', 'submit', '派工', '2026-01-08 08:30:00', '2026-01-08 09:00:00'),
(7, 'FIELD_SURVEY', '现场勘查', 4, '勘查员王五', 'submit', '现场勘查完成', '2026-01-08 09:00:00', '2026-01-10 16:00:00'),
(7, 'PLAN_DRAFT', '拟定供电方案', 5, '方案员赵六', 'submit', '方案拟定完成', '2026-01-10 16:00:00', '2026-01-13 09:00:00'),
(7, 'APPROVAL', '审批', 6, '审批员钱七', 'approve', '审批通过', '2026-01-13 09:00:00', '2026-01-14 09:30:00'),
(7, 'PLAN_REPLY', '答复供电方案', 7, '答复员孙八', 'submit', '书面答复客户', '2026-01-14 09:30:00', '2026-01-16 14:00:00'),
(7, 'FEE_DETERMINE', '确定费用', 8, '费用员周九', 'submit', '费用已确定', '2026-01-16 14:00:00', '2026-01-18 09:00:00'),
(7, 'FEE_COLLECTION', '业务收费', 9, '收费员吴十', 'submit', '费用已收讫', '2026-01-18 09:00:00', '2026-01-20 14:00:00'),
(7, 'PROJECT_TRACKING', '供电工程进度跟踪', 10, '工程管理员郑一', 'submit', '工程进度跟踪完成', '2026-01-20 14:00:00', '2026-04-30 16:00:00'),
(7, 'DESIGN_REVIEW', '设计文件审核', 11, '设计审核员陈二', 'submit', '设计文件审核通过', '2026-04-30 16:00:00', '2026-05-05 09:00:00'),
(7, 'MID_INSPECTION', '中间检查', 12, '检查员刘三', 'submit', '中间检查合格', '2026-05-05 09:00:00', '2026-05-08 16:00:00'),
(7, 'COMPLETION_APPLY', '竣工报验', 2, '受理员张三', 'submit', '竣工报验', '2026-05-08 16:00:00', '2026-05-10 09:00:00'),
(7, 'COMPLETION_CHECK', '竣工验收', 13, '验收员黄四', 'submit', '验收合格', '2026-05-10 09:00:00', '2026-05-20 14:00:00'),
(7, 'INFO_ARCHIVE', '信息归档', 14, '归档员林五', 'submit', '归档完成', '2026-05-20 14:00:00', '2026-05-25 10:00:00');

-- ============================================
-- 8. 中海国际社区 - 设计文件审核阶段
-- ============================================
INSERT IGNORE INTO application_info (id, application_no, business_type, customer_name, district, electricity_address, contact_person, contact_phone, cert_type, cert_no, electricity_category, capacity, industry_category, load_nature, power_supply_unit, household_count, remark, process_status, process_status_name, accept_user_id, accept_user_name, accept_time) VALUES
(8, 'SQ20260525001', 'NEW_INSTALL', '中海国际社区置业有限公司', '石景山区', '石景山区古城南路168号中海国际社区', '吴海', '13401008901', 'BUSINESS_LICENSE', '91110107MA00XXXXX8', 'L1', 6800.00, 'RESIDENTIAL', 'NORMAL', '国网石景山供电公司', 1000, '中高端住宅社区，共6栋楼，1000户。工程已完成，设计文件待审核', 'DESIGN_REVIEW', '设计文件审核', 2, '受理员张三', '2026-05-25 15:00:00');

INSERT IGNORE INTO customer_info (application_id, customer_name, cert_type, cert_no, legal_representative, address, contact_person, contact_phone, business_license_no, customer_type) VALUES
(8, '中海国际社区置业有限公司', 'BUSINESS_LICENSE', '91110107MA00XXXXX8', '吴海', '石景山区古城南路168号', '吴海', '13401008901', '91110107MA00XXXXX8', '企业');

INSERT IGNORE INTO electrical_equipment (application_id, equipment_name, equipment_type, quantity, unit_capacity, total_capacity, voltage_level, phase_type) VALUES
(8, '居民用电总负荷', '照明及家电', 1000, 5.00, 5000.00, '0.4kV', '三相'),
(8, '公共设施用电', '电梯水泵消防', 1, 1800.00, 1800.00, '10kV', '三相');

INSERT IGNORE INTO current_process (application_id, current_step, current_step_name, status, arrive_time) VALUES
(8, 'DESIGN_REVIEW', '设计文件审核', 'processing', '2026-05-30 09:00:00');

INSERT IGNORE INTO survey_dispatch (application_id, dispatch_mode, surveyor_id, surveyor_name, dispatcher_id, dispatcher_name, dispatch_time, status) VALUES
(8, 'single', 4, '勘查员王五', 3, '派工员李四', '2026-05-27 09:00:00', 'dispatched');

INSERT IGNORE INTO survey_info (application_id, surveyor_id, surveyor_name, survey_date, survey_time, survey_opinion, can_supply_power, approved_capacity, power_supply_mode, voltage_level, power_supply_unit, has_project, is_transfer, survey_version) VALUES
(8, 4, '勘查员王五', '2026-05-28', '2026-05-28 14:00:00', '现场勘查确认供电条件良好，建议10kV单电源供电', 1, 6800.00, 'HIGH_SINGLE', '10kV', '国网石景山供电公司', 1, 0, 1);

INSERT IGNORE INTO power_plan_info (application_id, approved_capacity, plan_opinion, plan_participants, plan_date, power_supply_mode, voltage_level, can_supply_power, power_supply_unit, has_project, is_transfer, plan_version) VALUES
(8, 6800.00, '同意10kV单电源供电方案，从220kV石景山变电站新出10kV线路', '方案员赵六', '2026-05-29', 'HIGH_SINGLE', '10kV', 1, '国网石景山供电公司', 1, 0, 1);

INSERT IGNORE INTO approval_info (application_id, approver_id, approver_name, approval_dept, is_approved, approval_opinion, approval_time) VALUES
(8, 6, '审批员钱七', '营销部', 1, '方案合理，同意。', '2026-05-29 16:00:00');

INSERT IGNORE INTO receivable_fee (id, application_id, fee_project, receivable_amount, fee_determine_time, fee_determiner_id, fee_determiner_name, fee_standard) VALUES
(4, 8, '配套费', 150000.00, '2026-05-30 08:30:00', 8, '费用员周九', '按面积150元/平方米');

INSERT IGNORE INTO process_record (application_id, process_step, process_step_name, operator_id, operator_name, operation, operation_comment, arrive_time, send_time) VALUES
(8, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'create', '受理', '2026-05-25 15:00:00', '2026-05-25 15:00:00'),
(8, 'BUSINESS_ACCEPTANCE', '业务受理', 2, '受理员张三', 'submit', '提交', '2026-05-25 15:00:00', '2026-05-27 09:00:00'),
(8, 'SURVEY_DISPATCH', '勘查派工', 3, '派工员李四', 'submit', '派工', '2026-05-27 09:00:00', '2026-05-27 09:00:00'),
(8, 'FIELD_SURVEY', '现场勘查', 4, '勘查员王五', 'submit', '勘查完成', '2026-05-27 09:00:00', '2026-05-29 09:00:00'),
(8, 'PLAN_DRAFT', '拟定供电方案', 5, '方案员赵六', 'submit', '方案拟定', '2026-05-29 09:00:00', '2026-05-29 14:00:00'),
(8, 'APPROVAL', '审批', 6, '审批员钱七', 'approve', '审批通过', '2026-05-29 14:00:00', '2026-05-29 16:00:00'),
(8, 'PLAN_REPLY', '答复供电方案', 7, '答复员孙八', 'submit', '答复完成', '2026-05-29 16:00:00', '2026-05-29 17:00:00'),
(8, 'FEE_DETERMINE', '确定费用', 8, '费用员周九', 'submit', '费用确定', '2026-05-29 17:00:00', '2026-05-30 08:30:00'),
(8, 'FEE_COLLECTION', '业务收费', 9, '收费员吴十', 'submit', '收费完成', '2026-05-30 08:30:00', '2026-05-30 09:00:00'),
(8, 'PROJECT_TRACKING', '供电工程进度跟踪', 10, '工程管理员郑一', 'submit', '工程跟踪完成，设计文件提交审核', '2026-05-30 09:00:00', '2026-05-30 09:00:00');

