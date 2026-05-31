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
            <el-button size="small" type="primary" @click="openFee(row)">确定费用</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="确定费用" width="500px">
      <el-form>
        <el-form-item label="是否有供电工程">
          <el-switch v-model="hasProject" />
        </el-form-item>
        <el-button size="small" @click="addFee">添加费用项</el-button>
        <el-table :data="fees" border style="margin-top:10px">
          <el-table-column label="收费项目"><template #default="{row}"><el-input v-model="row.feeProject" size="small" /></template></el-table-column>
          <el-table-column label="应收金额(元)" width="150"><template #default="{row}"><el-input-number v-model="row.receivableAmount" :min="0" :precision="2" size="small" /></template></el-table-column>
          <el-table-column label="收费标准"><template #default="{row}"><el-input v-model="row.feeStandard" size="small" /></template></el-table-column>
          <el-table-column label="操作" width="80"><template #default="{$index}"><el-button size="small" type="danger" @click="fees.splice($index,1)">删除</el-button></template></el-table-column>
        </el-table>
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
import { getProcessTaskList, determineFee } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false), currentAppId = ref(null), hasProject = ref(false)
const fees = ref([{ feeProject: '配套费', receivableAmount: 0, feeStandard: '按容量计收' }])

const addFee = () => fees.value.push({ feeProject: '', receivableAmount: 0, feeStandard: '' })
const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('fee-determine', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openFee = (row) => { currentAppId.value = row.id; dialogVisible.value = true; fees.value = [{ feeProject: '配套费', receivableAmount: 0, feeStandard: '按容量计收' }] }
const handleSave = async () => {
  await determineFee(currentAppId.value, { fees: fees.value, hasProject: hasProject.value, operatorId: 8, operatorName: '费用员' })
  ElMessage.success('费用已确定')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
