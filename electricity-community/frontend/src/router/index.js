import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/login', name: 'Login', component: () => import('../views/login/Login.vue'), meta: { noAuth: true } },
  {
    path: '/', component: () => import('../views/layout/MainLayout.vue'), redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'Dashboard', component: () => import('../views/dashboard/Dashboard.vue'), meta: { title: '首页' } },
      { path: 'business-acceptance', name: 'BusinessAcceptance', component: () => import('../views/business-acceptance/BusinessAcceptance.vue'), meta: { title: '业务受理' } },
      { path: 'business-acceptance/create', name: 'BusinessAcceptanceCreate', component: () => import('../views/business-acceptance/ApplicationCreate.vue'), meta: { title: '新建申请' } },
      { path: 'business-acceptance/:id', name: 'BusinessAcceptanceDetail', component: () => import('../views/business-acceptance/ApplicationDetail.vue'), meta: { title: '申请详情' } },
      { path: 'survey-dispatch', name: 'SurveyDispatch', component: () => import('../views/survey-dispatch/SurveyDispatch.vue'), meta: { title: '勘查派工' } },
      { path: 'field-survey', name: 'FieldSurvey', component: () => import('../views/field-survey/FieldSurvey.vue'), meta: { title: '现场勘查' } },
      { path: 'power-plan', name: 'PowerPlan', component: () => import('../views/power-plan/PowerPlan.vue'), meta: { title: '拟定供电方案' } },
      { path: 'approval', name: 'Approval', component: () => import('../views/approval/Approval.vue'), meta: { title: '审批' } },
      { path: 'plan-reply', name: 'PlanReply', component: () => import('../views/plan-reply/PlanReply.vue'), meta: { title: '答复供电方案' } },
      { path: 'fee-determine', name: 'FeeDetermine', component: () => import('../views/fee/FeeDetermine.vue'), meta: { title: '确定费用' } },
      { path: 'fee-collection', name: 'FeeCollection', component: () => import('../views/fee/FeeCollection.vue'), meta: { title: '业务收费' } },
      { path: 'project-tracking', name: 'ProjectTracking', component: () => import('../views/project-tracking/ProjectTracking.vue'), meta: { title: '供电工程进度跟踪' } },
      { path: 'design-review', name: 'DesignReview', component: () => import('../views/design-review/DesignReview.vue'), meta: { title: '设计文件审核' } },
      { path: 'mid-inspection', name: 'MidInspection', component: () => import('../views/mid-inspection/MidInspection.vue'), meta: { title: '中间检查' } },
      { path: 'completion-apply', name: 'CompletionApply', component: () => import('../views/completion/CompletionApply.vue'), meta: { title: '竣工报验' } },
      { path: 'completion-check', name: 'CompletionCheck', component: () => import('../views/completion/CompletionCheck.vue'), meta: { title: '竣工验收' } },
      { path: 'info-archive', name: 'InfoArchive', component: () => import('../views/info-archive/InfoArchive.vue'), meta: { title: '信息归档' } },
      { path: 'archive', name: 'Archive', component: () => import('../views/archive/Archive.vue'), meta: { title: '归档查询' } }
    ]
  }
]

const router = createRouter({ history: createWebHistory(), routes })

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  if (!to.meta.noAuth && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router
