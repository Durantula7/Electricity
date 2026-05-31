<template>
  <div>
    <el-card>
      <div style="margin-bottom:16px">
        <el-input v-model="keyword" placeholder="搜索申请编号/客户名称" clearable style="width:250px" @keyup.enter="fetchData" />
        <el-button type="primary" style="margin-left:10px" @click="fetchData">查询</el-button>
      </div>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="capacity" label="容量(kVA)" width="100" />
        <el-table-column prop="processStatusName" label="状态" width="120" />
        <el-table-column prop="acceptTime" label="受理时间" width="160" />
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="$router.push(`/business-acceptance/${row.id}`)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getApplicationList } from '../../api'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0), keyword = ref('')

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getApplicationList({ pageNum: pageNum.value, pageSize: pageSize.value, processStatus: 'FINISHED', keyword: keyword.value || undefined })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
onMounted(fetchData)
</script>
