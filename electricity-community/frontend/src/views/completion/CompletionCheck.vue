<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="success" @click="openCheck(row, true)">验收合格</el-button>
            <el-button size="small" type="danger" @click="openCheck(row, false)">验收不合格</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="check.isQualified ? '验收合格' : '验收不合格'" width="450px">
      <el-form label-width="120px">
        <el-form-item label="验收人"><el-input v-model="check.checkPerson" /></el-form-item>
        <el-form-item label="验收部门"><el-input v-model="check.checkDept" /></el-form-item>
        <el-form-item label="总体评价"><el-input v-model="check.overallAssessment" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button :type="check.isQualified ? 'success' : 'danger'" @click="handleSave">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, saveCompletionCheck } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false), currentAppId = ref(null)
const check = reactive({ checkPerson: '', checkDept: '', overallAssessment: '', isQualified: 1 })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('completion-check', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openCheck = (row, isQualified) => { currentAppId.value = row.id; check.isQualified = isQualified ? 1 : 0; dialogVisible.value = true }
const handleSave = async () => {
  await saveCompletionCheck(currentAppId.value, { ...check, operatorId: 13, operatorName: '验收员' })
  ElMessage.success(check.isQualified ? '验收合格，已提交' : '验收不合格，已退回')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
