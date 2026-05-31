<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="processStatusName" label="状态" width="120" />
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openArchive(row)">归档</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="信息归档" width="450px">
      <el-form label-width="120px">
        <el-form-item label="档案号"><el-input v-model="archiveForm.archiveNo" /></el-form-item>
        <el-form-item label="存放位置"><el-input v-model="archiveForm.archiveLocation" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">确认归档</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, archive } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false), currentAppId = ref(null)
const archiveForm = reactive({ archiveNo: '', archiveLocation: '' })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('info-archive', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openArchive = (row) => { currentAppId.value = row.id; archiveForm.archiveNo = 'DA' + Date.now(); dialogVisible.value = true }
const handleSave = async () => {
  await archive(currentAppId.value, { ...archiveForm, operatorId: 14, operatorName: '归档员' })
  ElMessage.success('归档完成')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
