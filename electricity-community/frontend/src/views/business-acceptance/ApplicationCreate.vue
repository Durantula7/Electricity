<template>
  <div>
    <el-card>
      <template #header><span>新建小区新装申请</span></template>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-divider content-position="left">申请信息</el-divider>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="客户名称" prop="customerName">
              <el-input v-model="form.customerName" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="行政区" prop="district">
              <el-input v-model="form.district" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="用电类别" prop="electricityCategory">
              <el-select v-model="form.electricityCategory" style="width:100%">
                <el-option label="居民生活用电" value="L1" />
                <el-option label="一般工商业用电" value="L2" />
                <el-option label="大工业用电" value="L3" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="用电地址" prop="electricityAddress">
              <el-input v-model="form.electricityAddress" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="申请容量(kVA)" prop="capacity">
              <el-input-number v-model="form.capacity" :min="0" :precision="2" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="申请户数" prop="householdCount">
              <el-input-number v-model="form.householdCount" :min="1" style="width:100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="联系人" prop="contactPerson">
              <el-input v-model="form.contactPerson" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系电话" prop="contactPhone">
              <el-input v-model="form.contactPhone" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="负荷性质">
              <el-select v-model="form.loadNature" style="width:100%">
                <el-option label="重要负荷" value="IMPORTANT" />
                <el-option label="普通负荷" value="NORMAL" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="证件类别">
              <el-select v-model="form.certType" style="width:100%">
                <el-option label="身份证" value="ID_CARD" />
                <el-option label="营业执照" value="BUSINESS_LICENSE" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证件号码" prop="certNo">
              <el-input v-model="form.certNo" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="行业类别">
              <el-input v-model="form.industryCategory" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" />
        </el-form-item>

        <el-divider content-position="left">客户资料</el-divider>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="营业执照号">
              <el-input v-model="customer.businessLicenseNo" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="法定代表人">
              <el-input v-model="customer.legalRepresentative" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="组织机构代码">
              <el-input v-model="customer.organizationCode" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="16">
            <el-form-item label="客户地址">
              <el-input v-model="customer.address" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户类型">
              <el-input v-model="customer.customerType" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">用电设备清单</el-divider>
        <el-button type="primary" size="small" @click="addEquipment">添加设备</el-button>
        <el-table :data="equipmentList" border style="margin-top:10px">
          <el-table-column label="设备名称"><template #default="{row}"><el-input v-model="row.equipmentName" size="small" /></template></el-table-column>
          <el-table-column label="设备类型"><template #default="{row}"><el-input v-model="row.equipmentType" size="small" /></template></el-table-column>
          <el-table-column label="数量" width="100"><template #default="{row}"><el-input-number v-model="row.quantity" :min="1" size="small" /></template></el-table-column>
          <el-table-column label="单台容量(kW)" width="130"><template #default="{row}"><el-input-number v-model="row.unitCapacity" :min="0" :precision="2" size="small" /></template></el-table-column>
          <el-table-column label="总容量(kW)" width="130"><template #default="{row}">{{ (row.quantity * row.unitCapacity || 0).toFixed(2) }}</template></el-table-column>
          <el-table-column label="电压等级" width="120"><template #default="{row}"><el-input v-model="row.voltageLevel" size="small" /></template></el-table-column>
          <el-table-column label="操作" width="80"><template #default="{$index}"><el-button size="small" type="danger" @click="equipmentList.splice($index,1)">删除</el-button></template></el-table-column>
        </el-table>

        <div style="margin-top:24px; text-align:center">
          <el-button @click="$router.back()">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="handleSubmit">提交申请</el-button>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { createApplication } from '../../api'
import { ElMessage } from 'element-plus'

const router = useRouter()
const formRef = ref(null)
const submitting = ref(false)
const form = reactive({
  customerName: '', district: '', electricityAddress: '', electricityCategory: 'L1',
  capacity: null, householdCount: 1, contactPerson: '', contactPhone: '',
  certType: '', certNo: '', loadNature: 'NORMAL', industryCategory: '', remark: '',
  businessType: 'NEW_INSTALL', powerSupplyUnit: '供电公司'
})
const rules = {
  customerName: [{ required: true, message: '请输入客户名称', trigger: 'blur' }],
  electricityAddress: [{ required: true, message: '请输入用电地址', trigger: 'blur' }],
  electricityCategory: [{ required: true, message: '请选择用电类别', trigger: 'change' }],
  capacity: [{ required: true, message: '请输入容量', trigger: 'blur' }],
  contactPerson: [{ required: true, message: '请输入联系人', trigger: 'blur' }],
  contactPhone: [{ required: true, message: '请输入联系电话', trigger: 'blur' }]
}
const customer = reactive({ businessLicenseNo: '', legalRepresentative: '', organizationCode: '', address: '', customerType: '', customerName: '' })
const equipmentList = ref([])

const addEquipment = () => {
  equipmentList.value.push({ equipmentName: '', equipmentType: '', quantity: 1, unitCapacity: 0, voltageLevel: '0.4kV', phaseType: '三相' })
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    customer.customerName = form.customerName
    await createApplication({
      application: { ...form },
      customer: { ...customer },
      equipment: equipmentList.value,
      operatorId: 2, operatorName: '受理员'
    })
    ElMessage.success('申请创建成功')
    router.push('/business-acceptance')
  } finally { submitting.value = false }
}
</script>
