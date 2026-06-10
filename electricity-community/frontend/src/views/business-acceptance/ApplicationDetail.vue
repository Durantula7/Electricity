<template>
  <div>
    <el-card v-loading="loading">
      <template #header>
        <div style="display:flex; justify-content:space-between; align-items:center">
          <span>申请详情 - {{ app?.applicationNo }}</span>
          <el-tag>{{ app?.processStatusName }}</el-tag>
        </div>
      </template>
      <el-descriptions :column="3" border>
        <el-descriptions-item label="申请编号">{{ app?.applicationNo }}</el-descriptions-item>
        <el-descriptions-item label="客户名称">{{ app?.customerName }}</el-descriptions-item>
        <el-descriptions-item label="行政区">{{ app?.district }}</el-descriptions-item>
        <el-descriptions-item label="用电地址">{{ app?.electricityAddress }}</el-descriptions-item>
        <el-descriptions-item label="用电类别">{{ app?.electricityCategory }}</el-descriptions-item>
        <el-descriptions-item label="申请容量(kVA)">{{ app?.capacity }}</el-descriptions-item>
        <el-descriptions-item label="联系人">{{ app?.contactPerson }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ app?.contactPhone }}</el-descriptions-item>
        <el-descriptions-item label="负荷性质">{{ app?.loadNature }}</el-descriptions-item>
        <el-descriptions-item label="受理时间">{{ app?.acceptTime }}</el-descriptions-item>
        <el-descriptions-item label="证件号码">{{ app?.certNo }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ app?.remark }}</el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">流程历史</el-divider>
      <el-timeline>
        <el-timeline-item v-for="record in processHistory" :key="record.id" :timestamp="record.sendTime" placement="top">
          <el-card><div><strong>{{ record.processStepName }}</strong> - {{ record.operation }} - {{ record.operatorName }}</div><div v-if="record.operationComment" style="color:#909399; margin-top:4px">{{ record.operationComment }}</div></el-card>
        </el-timeline-item>
      </el-timeline>

      <!-- 业务受理环节：提交到下一环节（勘查派工） -->
      <div style="text-align:center; margin-top:20px" v-if="isBusinessAcceptance">
        <el-input v-model="comment" placeholder="提交意见" style="width:300px; margin-right:10px" />
        <el-button type="primary" @click="handleSubmit">提交到下一环节</el-button>
      </div>
      <!-- 其他环节：跳转到对应处理页面 -->
      <div style="text-align:center; margin-top:20px" v-else-if="canGoToProcess">
        <el-button type="primary" size="large" @click="$router.push(currentStepRoute)">前往【{{ nextStepName }}】处理</el-button>
      </div>
      <!-- 已办结/归档：无操作 -->
      <div style="text-align:center; margin-top:20px; color:#909399" v-else>
        该工单已处理完毕
      </div>
      <el-button style="margin-top:10px" @click="$router.back()">返回</el-button>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getApplicationDetail, getProcessHistory, submitApplication } from '../../api'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const app = ref(null)
const processHistory = ref([])
const comment = ref('')

const stepRouteMap = {
  'BUSINESS_ACCEPTANCE': null,
  'SURVEY_DISPATCH': '/survey-dispatch',
  'FIELD_SURVEY': '/field-survey',
  'PLAN_DRAFT': '/power-plan',
  'APPROVAL': '/approval',
  'PLAN_REPLY': '/plan-reply',
  'FEE_DETERMINE': '/fee-determine',
  'FEE_COLLECTION': '/fee-collection',
  'PROJECT_TRACKING': '/project-tracking',
  'DESIGN_REVIEW': '/design-review',
  'MID_INSPECTION': '/mid-inspection',
  'COMPLETION_APPLY': '/completion-apply',
  'COMPLETION_CHECK': '/completion-check',
  'INFO_ARCHIVE': '/info-archive'
}

const nextStepName = computed(() => {
  if (!app.value) return ''
  const status = app.value.processStatus
  const names = {
    'SURVEY_DISPATCH': '勘查派工', 'FIELD_SURVEY': '现场勘查', 'PLAN_DRAFT': '拟定供电方案',
    'APPROVAL': '审批', 'PLAN_REPLY': '答复供电方案', 'FEE_DETERMINE': '确定费用',
    'FEE_COLLECTION': '业务收费', 'PROJECT_TRACKING': '供电工程进度跟踪', 'DESIGN_REVIEW': '设计文件审核',
    'MID_INSPECTION': '中间检查', 'COMPLETION_APPLY': '竣工报验', 'COMPLETION_CHECK': '竣工验收',
    'INFO_ARCHIVE': '信息归档'
  }
  return names[status] || ''
})

const currentStepRoute = computed(() => {
  if (!app.value) return null
  return stepRouteMap[app.value.processStatus] || null
})

const isBusinessAcceptance = computed(() => {
  return app.value?.processStatus === 'BUSINESS_ACCEPTANCE'
})

const canGoToProcess = computed(() => {
  if (!app.value) return false
  const status = app.value.processStatus
  return ['SURVEY_DISPATCH', 'FIELD_SURVEY', 'PLAN_DRAFT', 'APPROVAL', 'PLAN_REPLY', 'FEE_DETERMINE', 'FEE_COLLECTION', 'PROJECT_TRACKING', 'DESIGN_REVIEW', 'MID_INSPECTION', 'COMPLETION_APPLY', 'COMPLETION_CHECK', 'INFO_ARCHIVE'].includes(status)
})

const fetchData = async () => {
  loading.value = true
  try {
    const [appRes, historyRes] = await Promise.all([
      getApplicationDetail(route.params.id),
      getProcessHistory(route.params.id)
    ])
    app.value = appRes.data
    processHistory.value = historyRes.data
  } finally { loading.value = false }
}

const handleSubmit = async () => {
  try {
    await submitApplication(route.params.id, {
      operatorId: 2,
      operatorName: '操作员',
      comment: comment.value || '提交'
    })
    ElMessage.success('提交成功')
    comment.value = ''
    await fetchData()
  } catch (e) {
    // error handled by interceptor
  }
}

onMounted(fetchData)
</script>
