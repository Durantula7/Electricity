<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="capacity" label="容量(kVA)" width="100" />
        <el-table-column prop="contactPhone" label="联系电话" width="120" />
        <el-table-column prop="acceptTime" label="受理时间" width="160" />
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openDispatch(row)">派工</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="勘查派工" width="450px">
      <el-form label-width="100px">
        <el-form-item label="勘查人员">
          <el-select v-model="dispatch.surveyorId" style="width:100%">
            <el-option label="勘查员王五" :value="4" />
            <el-option label="勘查员赵六" :value="5" />
          </el-select>
        </el-form-item>
        <el-form-item label="派工方式">
          <el-radio-group v-model="dispatch.dispatchMode">
            <el-radio label="single">单个派工</el-radio>
            <el-radio label="batch">批量派工</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleDispatch">确认派工</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, dispatchSurvey } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const tableData = ref([])
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const currentAppId = ref(null)
const dispatch = reactive({ surveyorId: 4, surveyorName: '勘查员王五', dispatchMode: 'single' })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('survey-dispatch', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}

const openDispatch = (row) => {
  currentAppId.value = row.id
  dialogVisible.value = true
}

const handleDispatch = async () => {
  await dispatchSurvey(currentAppId.value, {
    surveyorId: dispatch.surveyorId,
    surveyorName: dispatch.surveyorId === 4 ? '勘查员王五' : '勘查员赵六',
    operatorId: 3, operatorName: '派工员',
    dispatchMode: dispatch.dispatchMode
  })
  ElMessage.success('派工成功')
  dialogVisible.value = false
  fetchData()
}

onMounted(fetchData)
</script>
