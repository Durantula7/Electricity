<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="capacity" label="容量(kVA)" width="100" />
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openTracking(row)">登记</el-button>
            <el-button size="small" type="success" @click="handleSubmit(row)">完成</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="供电工程进度登记" width="500px">
      <el-tabs>
        <el-tab-pane label="设计信息">
          <el-form label-width="100px">
            <el-form-item label="工程名称"><el-input v-model="tracking.projectName" /></el-form-item>
            <el-form-item label="设计单位"><el-input v-model="tracking.designUnit" /></el-form-item>
            <el-form-item label="设计内容"><el-input v-model="tracking.designContent" type="textarea" /></el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="工程施工">
          <el-form label-width="100px">
            <el-form-item label="施工单位"><el-input v-model="tracking.constructionUnit" /></el-form-item>
            <el-form-item label="开工日期"><el-date-picker v-model="tracking.startDate" style="width:100%" /></el-form-item>
            <el-form-item label="预计完工"><el-date-picker v-model="tracking.expectedCompletionDate" style="width:100%" /></el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="工程预算">
          <el-form label-width="120px">
            <el-form-item label="预算费用"><el-input-number v-model="tracking.budgetAmount" :min="0" :precision="2" style="width:100%" /></el-form-item>
            <el-form-item label="预算人"><el-input v-model="tracking.budgetPerson" /></el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
      <template #footer>
        <el-button @click="dialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, submitTracking } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false)
const tracking = reactive({ projectName: '', designUnit: '', designContent: '', constructionUnit: '', startDate: null, expectedCompletionDate: null, budgetAmount: 0, budgetPerson: '' })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('project-tracking', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openTracking = (row) => { dialogVisible.value = true }
const handleSubmit = async (row) => {
  await submitTracking(row.id, { operatorId: 10, operatorName: '工程管理员' })
  ElMessage.success('提交完成')
  fetchData()
}
onMounted(fetchData)
</script>
