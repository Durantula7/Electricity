<template>
  <div>
    <el-card>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="applicationNo" label="申请编号" width="180" />
        <el-table-column prop="customerName" label="客户名称" width="150" />
        <el-table-column prop="electricityAddress" label="用电地址" min-width="200" />
        <el-table-column prop="capacity" label="申请容量(kVA)" width="120" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="openSurvey(row)">勘查录入</el-button>
            <el-button size="small" @click="$router.push(`/business-acceptance/${row.id}`)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination style="margin-top:16px; text-align:right" v-model:current-page="pageNum" :page-size="pageSize" :total="total" layout="total,prev,pager,next" @change="fetchData" />
    </el-card>
    <el-dialog v-model="dialogVisible" title="现场勘查" width="600px">
      <el-form label-width="120px">
        <el-form-item label="勘查意见"><el-input v-model="survey.surveyOpinion" type="textarea" /></el-form-item>
        <el-form-item label="是否可供电"><el-switch v-model="survey.canSupplyPower" /></el-form-item>
        <template v-if="survey.canSupplyPower">
          <el-form-item label="核定容量(kVA)"><el-input-number v-model="survey.approvedCapacity" :min="0" style="width:100%" /></el-form-item>
          <el-form-item label="供电方式"><el-select v-model="survey.powerSupplyMode" style="width:100%"><el-option label="高压单电源" value="HIGH_SINGLE" /><el-option label="高压双电源" value="HIGH_DUAL" /><el-option label="低压单电源" value="LOW_SINGLE" /></el-select></el-form-item>
          <el-form-item label="电压等级"><el-select v-model="survey.voltageLevel" style="width:100%"><el-option label="10kV" value="10kV" /><el-option label="0.4kV" value="0.4kV" /><el-option label="35kV" value="35kV" /></el-select></el-form-item>
          <el-form-item label="是否有工程"><el-switch :model-value="survey.hasProject===1" @change="survey.hasProject=$event?1:0" /></el-form-item>
        </template>
        <template v-else><el-form-item label="不可供电原因"><el-input v-model="survey.cannotReason" type="textarea" /></el-form-item></template>
      </el-form>
      <template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="handleSave">保存并提交</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProcessTaskList, saveSurvey } from '../../api'
import { ElMessage } from 'element-plus'
const loading=ref(false),tableData=ref([]),pageNum=ref(1),pageSize=ref(10),total=ref(0),dialogVisible=ref(false),currentAppId=ref(null)
const survey=reactive({surveyOpinion:'',canSupplyPower:true,approvedCapacity:null,powerSupplyMode:'HIGH_SINGLE',voltageLevel:'10kV',hasProject:1,isTransfer:0,cannotReason:''})
const fetchData=async()=>{loading.value=true;try{const r=await getProcessTaskList('field-survey',{pageNum:pageNum.value,pageSize:pageSize.value});if(r.code===200){tableData.value=r.data.records;total.value=r.data.total}}finally{loading.value=false}}
const openSurvey=(row)=>{currentAppId.value=row.id;Object.assign(survey,{surveyOpinion:'',canSupplyPower:true,approvedCapacity:null,powerSupplyMode:'HIGH_SINGLE',voltageLevel:'10kV',hasProject:1,cannotReason:''});dialogVisible.value=true}
const handleSave=async()=>{await saveSurvey(currentAppId.value,{...survey,operatorId:4,operatorName:'勘查员'});ElMessage.success('勘查完成');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
