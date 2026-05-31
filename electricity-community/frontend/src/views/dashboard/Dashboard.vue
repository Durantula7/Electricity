<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="6" v-for="card in statCards" :key="card.title">
        <el-card shadow="hover" style="cursor:pointer" @click="$router.push(card.route)">
          <div style="display:flex; align-items:center; justify-content:space-between">
            <div>
              <div style="font-size:13px; color:#909399">{{ card.title }}</div>
              <div style="font-size:28px; font-weight:bold; margin-top:8px; color:#303133">{{ card.count }}</div>
            </div>
            <el-icon :size="40" :color="card.color"><component :is="card.icon" /></el-icon>
          </div>
        </el-card>
      </el-col>
    </el-row>
    <el-card style="margin-top:20px" header="快捷操作">
      <el-row :gutter="12">
        <el-col :span="4" v-for="action in quickActions" :key="action.label">
          <el-button style="width:100%; height:60px" @click="$router.push(action.route)">
            {{ action.label }}
          </el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-card style="margin-top:20px" header="流程概览">
      <el-steps :active="3" align-center>
        <el-step title="业务受理" description="提交申请资料" />
        <el-step title="现场勘查" description="勘查派工与现场勘查" />
        <el-step title="供电方案" description="拟定方案与审批" />
        <el-step title="答复收费" description="答复方案与收费" />
        <el-step title="工程管理" description="工程跟踪与审核" />
        <el-step title="竣工验收" description="竣工报验与验收" />
        <el-step title="归档" description="信息归档" />
      </el-steps>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getDashboardStats } from '../../api'

const statCards = ref([
  { title: '待受理', count: 0, color: '#409eff', icon: 'Document', route: '/business-acceptance' },
  { title: '待勘查', count: 0, color: '#e6a23c', icon: 'Search', route: '/survey-dispatch' },
  { title: '待审批', count: 0, color: '#67c23a', icon: 'Check', route: '/approval' },
  { title: '全部工单', count: 0, color: '#909399', icon: 'Tickets', route: '/business-acceptance' }
])

const quickActions = ref([
  { label: '新建申请', route: '/business-acceptance/create' },
  { label: '勘查派工', route: '/survey-dispatch' },
  { label: '方案审批', route: '/approval' },
  { label: '竣工验收', route: '/completion-check' },
  { label: '信息归档', route: '/info-archive' },
  { label: '归档查询', route: '/archive' }
])

onMounted(async () => {
  try {
    const res = await getDashboardStats()
    const s = res.data
    statCards.value[0].count = s.businessAcceptance || 0
    statCards.value[1].count = (s.surveyDispatch || 0) + (s.fieldSurvey || 0)
    statCards.value[2].count = s.approval || 0
    statCards.value[3].count = s.total || 0
  } catch (e) {
    console.error('获取统计数据失败', e)
  }
})
</script>
