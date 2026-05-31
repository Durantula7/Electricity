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
            <el-button size="small" type="primary" @click="openReply(row)">答复</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>

    <el-dialog v-model="dialogVisible" title="答复供电方案" width="450px">
      <el-form label-width="120px">
        <el-form-item label="答复方式">
          <el-select v-model="reply.replyMethod" style="width:100%">
            <el-option label="书面答复" value="WRITTEN" />
            <el-option label="电话答复" value="PHONE" />
            <el-option label="当面答复" value="FACE" />
          </el-select>
        </el-form-item>
        <el-form-item label="客户签收人">
          <el-input v-model="reply.customerSignee" />
        </el-form-item>
        <el-form-item label="客户意见">
          <el-input v-model="reply.customerOpinion" type="textarea" />
        </el-form-item>
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
import { getProcessTaskList, saveReply } from '../../api'
import { ElMessage } from 'element-plus'

const loading = ref(false), tableData = ref([]), pageNum = ref(1), pageSize = ref(10), total = ref(0)
const dialogVisible = ref(false), currentAppId = ref(null)
const reply = reactive({ replyMethod: 'WRITTEN', customerSignee: '', customerOpinion: '', replyMode: 'WRITTEN' })

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getProcessTaskList('plan-reply', { pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 200) { tableData.value = res.data.records; total.value = res.data.total }
  } finally { loading.value = false }
}
const openReply = (row) => { currentAppId.value = row.id; dialogVisible.value = true }
const handleSave = async () => {
  await saveReply(currentAppId.value, { ...reply, operatorId: 7, operatorName: '答复员' })
  ElMessage.success('答复完成')
  dialogVisible.value = false
  fetchData()
}
onMounted(fetchData)
</script>
