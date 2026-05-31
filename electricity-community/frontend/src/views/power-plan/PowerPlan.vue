<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="capacity" label="容量(kVA)" width="100" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openPlan(row)">拟定方案</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px;text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>
    <el-dialog v-model="dialogVisible" title="拟定供电方案" width="600px">
      <el-form label-width="140px">
        <el-form-item label="方案意见"><el-input v-model="plan.planOpinion" type="textarea" /></el-form-item>
        <el-form-item label="参与人"><el-input v-model="plan.planParticipants" /></el-form-item>
        <el-form-item label="核定容量(kVA)"><el-input-number v-model="plan.approvedCapacity" :min="0" style="width:100%" /></el-form-item>
        <el-form-item label="供电方式"><el-select v-model="plan.powerSupplyMode" style="width:100%"><el-option label="高压单电源" value="HIGH_SINGLE" /><el-option label="高压双电源" value="HIGH_DUAL" /></el-select></el-form-item>
        <el-form-item label="电压等级"><el-select v-model="plan.voltageLevel" style="width:100%"><el-option label="10kV" value="10kV" /><el-option label="0.4kV" value="0.4kV" /></el-select></el-form-item>
        <el-form-item label="是否可供电"><el-switch :model-value="plan.canSupplyPower===1" @change="plan.canSupplyPower=$event?1:0" /></el-form-item>
        <el-form-item label="是否有工程"><el-switch :model-value="plan.hasProject===1" @change="plan.hasProject=$event?1:0" /></el-form-item>
        <el-form-item label="接入系统方案"><el-input v-model="plan.accessSystemPlan" type="textarea" /></el-form-item>
        <el-form-item label="受电系统方案"><el-input v-model="plan.receivingSystemPlan" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="handleSave">保存并提交</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, savePowerPlan } from '../../api'
import { ElMessage } from 'element-plus'
const loading=ref(false),tableData=ref([]),pageNum=ref(1),pageSize=ref(10),total=ref(0),dialogVisible=ref(false),currentAppId=ref(null)
const plan=reactive({planOpinion:'',planParticipants:'',approvedCapacity:null,powerSupplyMode:'HIGH_SINGLE',voltageLevel:'10kV',canSupplyPower:1,hasProject:1,isTransfer:0,accessSystemPlan:'',receivingSystemPlan:''})
const fetchData=async()=>{loading.value=true;try{const r=await getProcessTaskList('power-plan',{pageNum:pageNum.value,pageSize:pageSize.value});if(r.code===200){tableData.value=r.data.records;total.value=r.data.total}}finally{loading.value=false}}
const openPlan=(row)=>{currentAppId.value=row.id;dialogVisible.value=true}
const handleSave=async()=>{await savePowerPlan(currentAppId.value,{...plan,operatorId:5,operatorName:'方案员'});ElMessage.success('方案拟定完成');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
