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
