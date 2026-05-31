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

      <div style="text-align:center; margin-top:20px" v-if="canSubmit">
        <el-input v-model="comment" placeholder="提交意见" style="width:300px; margin-right:10px" />
        <el-button type="primary" @click="handleSubmit">提交到下一环节</el-button>
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

const canSubmit = computed(() => {
  if (!app.value) return false
  const status = app.value.processStatus
  return ['BUSINESS_ACCEPTANCE', 'SURVEY_DISPATCH', 'FIELD_SURVEY', 'PLAN_DRAFT', 'APPROVAL', 'PLAN_REPLY', 'FEE_DETERMINE', 'FEE_COLLECTION', 'PROJECT_TRACKING', 'DESIGN_REVIEW', 'MID_INSPECTION', 'COMPLETION_APPLY', 'COMPLETION_CHECK', 'INFO_ARCHIVE'].includes(status)
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
  await submitApplication(route.params.id, { operatorId: 2, operatorName: '操作员' })
  ElMessage.success('提交成功')
  fetchData()
}

onMounted(fetchData)
</script>
