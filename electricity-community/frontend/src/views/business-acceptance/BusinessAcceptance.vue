<template>
  <div>
    <el-card>
      <div style="display:flex; justify-content:space-between; margin-bottom:16px">
        <div>
          <el-select v-model="filterStatus" placeholder="流程状态" clearable style="width:180px" @change="fetchData">
            <el-option label="业务受理" value="BUSINESS_ACCEPTANCE" />
            <el-option label="勘查派工" value="SURVEY_DISPATCH" />
            <el-option label="现场勘查" value="FIELD_SURVEY" />
            <el-option label="拟定供电方案" value="PLAN_DRAFT" />
            <el-option label="审批" value="APPROVAL" />
            <el-option label="答复供电方案" value="PLAN_REPLY" />
            <el-option label="确定费用" value="FEE_DETERMINE" />
            <el-option label="业务收费" value="FEE_COLLECTION" />
            <el-option label="供电工程进度跟踪" value="PROJECT_TRACKING" />
            <el-option label="设计文件审核" value="DESIGN_REVIEW" />
            <el-option label="中间检查" value="MID_INSPECTION" />
            <el-option label="竣工报验" value="COMPLETION_APPLY" />
            <el-option label="竣工验收" value="COMPLETION_CHECK" />
            <el-option label="信息归档" value="INFO_ARCHIVE" />
            <el-option label="已办结" value="FINISHED" />
          </el-select>
          <el-input v-model="keyword" placeholder="搜索申请编号/客户名称" clearable style="width:250px; margin-left:10px" @keyup.enter="fetchData" />
          <el-button type="primary" style="margin-left:10px" @click="fetchData">查询</el-button>
        </div>
        <el-button type="primary" @click="$router.push('/business-acceptance/create')">新建申请</el-button>
      </div>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="electricityCategory" label="用电类别" width="120" />
        <el-table-column prop="capacity" label="容量(kVA)" width="100" />
        <el-table-column prop="contactPerson" label="联系人" width="80" />
        <el-table-column prop="contactPhone" label="联系电话" width="120" />
        <el-table-column prop="processStatusName" label="当前状态" width="130">
          <template #default="{ row }"><el-tag size="small">{{ row.processStatusName }}</el-tag></template>
        </el-table-column>
        <el-table-column prop="acceptTime" label="受理时间" width="160" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="$router.push(`/business-acceptance/${row.id}`)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top:16px; text-align:right">
        <el-pagination v-model:current-page="pageNum" v-model:page-size="pageSize" :total="total" :page-sizes="[10,20,50]" layout="total,sizes,prev,pager,next" @change="fetchData" />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getApplicationList } from '../../api'

const loading = ref(false)
const tableData = ref([])
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const filterStatus = ref('')
const keyword = ref('')

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getApplicationList({ pageNum: pageNum.value, pageSize: pageSize.value, processStatus: filterStatus.value || undefined, keyword: keyword.value || undefined })
    if (res.code === 200) {
      tableData.value = res.data.records
      total.value = res.data.total
    }
  } finally { loading.value = false }
}

onMounted(fetchData)
</script>
