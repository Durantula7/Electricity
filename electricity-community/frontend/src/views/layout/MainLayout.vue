<template>
  <el-container style="height:100%">
    <el-aside width="220px" style="background:#304156; overflow-y:auto">
      <div style="height:60px; display:flex; align-items:center; justify-content:center; color:#fff; font-size:16px; font-weight:bold; border-bottom:1px solid #4a5b6b">
        小区新装管理系统
      </div>
      <el-menu :default-active="activeRoute" background-color="#304156" text-color="#bfcbd9" active-text-color="#409eff" router>
        <el-menu-item index="/dashboard">
          <el-icon><HomeFilled /></el-icon><span>首页</span>
        </el-menu-item>
        <el-sub-menu index="biz">
          <template #title><el-icon><Document /></el-icon><span>业务处理</span></template>
          <el-menu-item index="/business-acceptance">业务受理</el-menu-item>
          <el-menu-item index="/survey-dispatch">勘查派工</el-menu-item>
          <el-menu-item index="/field-survey">现场勘查</el-menu-item>
          <el-menu-item index="/power-plan">拟定供电方案</el-menu-item>
          <el-menu-item index="/approval">审批</el-menu-item>
          <el-menu-item index="/plan-reply">答复供电方案</el-menu-item>
          <el-menu-item index="/fee-determine">确定费用</el-menu-item>
          <el-menu-item index="/fee-collection">业务收费</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="eng">
          <template #title><el-icon><Setting /></el-icon><span>工程管理</span></template>
          <el-menu-item index="/project-tracking">供电工程进度跟踪</el-menu-item>
          <el-menu-item index="/design-review">设计文件审核</el-menu-item>
          <el-menu-item index="/mid-inspection">中间检查</el-menu-item>
        </el-sub-menu>
        <el-sub-menu index="completion">
          <template #title><el-icon><Checked /></el-icon><span>竣工验收</span></template>
          <el-menu-item index="/completion-apply">竣工报验</el-menu-item>
          <el-menu-item index="/completion-check">竣工验收</el-menu-item>
        </el-sub-menu>
        <el-menu-item index="/info-archive">
          <el-icon><Folder /></el-icon><span>信息归档</span>
        </el-menu-item>
        <el-menu-item index="/archive">
          <el-icon><FolderOpened /></el-icon><span>归档查询</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header style="background:#fff; border-bottom:1px solid #e6e6e6; display:flex; align-items:center; justify-content:space-between; padding:0 20px">
        <span style="font-size:14px; color:#666">{{ $route.meta.title || '首页' }}</span>
        <div>
          <span style="margin-right:10px; font-size:13px; color:#666">{{ userStore.username || '管理员' }}</span>
          <el-button size="small" @click="logout">退出</el-button>
        </div>
      </el-header>
      <el-main style="background:#f0f2f5">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '../../stores/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const activeRoute = computed(() => route.path)

const logout = () => {
  localStorage.removeItem('token')
  router.push('/login')
}
</script>
