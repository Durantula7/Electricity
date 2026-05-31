<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="capacity" label="容量(kVA)" width="100" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" type="success" @click="openApprove(row, true)">同意</el-button>
            <el-button size="small" type="danger" @click="openApprove(row, false)">不同意</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="approveForm.isApproved ? '审批通过' : '审批不通过'" width="450px">
      <el-form>
        <el-form-item label="审批意见">
          <el-input v-model="approveForm.opinion" type="textarea" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button :type="approveForm.isApproved ? 'success' : 'danger'" @click="handleApprove">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, approve } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const tableData = ref([])
const pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false)
const currentAppId = ref(null)
const approveForm = reactive({ isApproved: true, opinion: '' })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('approval', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}

const openApprove = (row, isApproved) => { currentAppId.value = row.id; approveForm.isApproved = isApproved; approveForm.opinion = ''; dialogVisible.value = true }
const handleApprove = async () => {
  await approve(currentAppId.value, { isApproved: approveForm.isApproved, opinion: approveForm.opinion, operatorId: 6, operatorName: '审批员', dept: '营销部' })
  ElMessage.success(approveForm.isApproved ? '审批通过' : '已退回')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
