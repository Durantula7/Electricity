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
            <el-button size="small" type="primary" @click="openCollect(row)">收费</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="业务收费" width="450px">
      <el-form label-width="120px">
        <el-form-item label="收费项目">
          <el-input v-model="collect.feeProject" />
        </el-form-item>
        <el-form-item label="实收金额(元)">
          <el-input-number v-model="collect.receivedAmount" :min="0" :precision="2" style="width:100%" />
        </el-form-item>
        <el-form-item label="缴费方式">
          <el-select v-model="collect.paymentMethod" style="width:100%">
            <el-option label="现金" value="CASH" />
            <el-option label="银行转账" value="BANK" />
            <el-option label="支票" value="CHECK" />
          </el-select>
        </el-form-item>
        <el-form-item label="发票号">
          <el-input v-model="collect.invoiceNo" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">确认收费</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, collectFee } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false), currentAppId = ref(null)
const collect = reactive({ feeProject: '配套费', receivedAmount: 0, paymentMethod: 'CASH', invoiceNo: '', receivableFeeId: 1 })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('fee-collection', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openCollect = (row) => { currentAppId.value = row.id; dialogVisible.value = true; collect.receivedAmount = 0; collect.invoiceNo = '' }
const handleSave = async () => {
  await collectFee(currentAppId.value, { ...collect, operatorId: 9, operatorName: '收费员', dept: '财务部' })
  ElMessage.success('收费完成')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
