<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openInspection(row)">检查</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="中间检查" width="500px">
      <el-form label-width="120px">
        <el-form-item label="检查人"><el-input v-model="inspection.inspector" /></el-form-item>
        <el-form-item label="检查内容"><el-input v-model="inspection.inspectionContent" type="textarea" /></el-form-item>
        <el-form-item label="检查结果">
          <el-radio-group v-model="inspection.inspectionResult">
            <el-radio label="合格">合格</el-radio>
            <el-radio label="不合格">不合格</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="缺陷描述"><el-input v-model="inspection.defectDescription" type="textarea" /></el-form-item>
        <el-form-item label="需要整改"><el-switch :model-value="inspection.rectificationRequired === 1" @change="inspection.rectificationRequired = $event ? 1 : 0" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存并提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, saveMidInspection } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false), currentAppId = ref(null)
const inspection = reactive({ inspector: '', inspectionContent: '', inspectionResult: '合格', defectDescription: '', rectificationRequired: 0 })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('mid-inspection', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openInspection = (row) => { currentAppId.value = row.id; dialogVisible.value = true }
const handleSave = async () => {
  await saveMidInspection(currentAppId.value, { ...inspection, operatorId: 12, operatorName: '检查员' })
  ElMessage.success('检查完成')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
