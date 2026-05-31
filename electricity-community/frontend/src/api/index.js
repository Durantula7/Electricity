import axios from 'axios'
import { ElMessage } from 'element-plus'

const request = axios.create({ baseURL: '/api', timeout: 30000 })

request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

request.interceptors.response.use(
  response => response.data,
  error => {
    const msg = error.response?.data?.message || '请求失败'
    ElMessage.error(msg)
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default request

// Auth
export const login = (data) => request.post('/auth/login', data)

// Application
export const getDashboardStats = () => request.get('/application/stats')
export const createApplication = (data) => request.post('/application', data)
export const getApplicationList = (params) => request.get('/application/list', { params })
export const getApplicationDetail = (id) => request.get(`/application/${id}`)
export const getCustomerInfo = (id) => request.get(`/application/${id}/customer`)
export const getEquipmentList = (id) => request.get(`/application/${id}/equipment`)
export const getProcessHistory = (id) => request.get(`/application/${id}/process-history`)
export const submitApplication = (id, data) => request.post(`/application/${id}/submit`, data)
export const getMyTasks = (params) => request.get('/application/my-tasks', { params })

// Process steps - generic list
export const getProcessTaskList = (step, params) => request.get(`/process/${step}/list`, { params })

// Survey dispatch
export const dispatchSurvey = (id, data) => request.post(`/process/survey-dispatch/${id}/dispatch`, data)
export const recallDispatch = (id, data) => request.post(`/process/survey-dispatch/${id}/recall`, data)

// Field survey
export const saveSurvey = (id, data) => request.post(`/process/field-survey/${id}/save`, data)

// Power plan
export const savePowerPlan = (id, data) => request.post(`/process/power-plan/${id}/save`, data)

// Approval
export const approve = (id, data) => request.post(`/process/approval/${id}/approve`, data)

// Plan reply
export const saveReply = (id, data) => request.post(`/process/plan-reply/${id}/save`, data)

// Fee
export const determineFee = (id, data) => request.post(`/process/fee-determine/${id}/save`, data)
export const collectFee = (id, data) => request.post(`/process/fee-collection/${id}/collect`, data)

// Project tracking
export const getTrackingData = (id) => request.get(`/process/project-tracking/${id}/data`)
export const submitTracking = (id, data) => request.post(`/process/project-tracking/${id}/submit`, data)

// Design review
export const saveDesignReview = (id, data) => request.post(`/process/design-review/${id}/save`, data)

// Mid inspection
export const saveMidInspection = (id, data) => request.post(`/process/mid-inspection/${id}/save`, data)

// Completion
export const saveCompletionApply = (id, data) => request.post(`/process/completion-apply/${id}/save`, data)
export const saveCompletionCheck = (id, data) => request.post(`/process/completion-check/${id}/save`, data)

// Archive
export const archive = (id, data) => request.post(`/process/info-archive/${id}/archive`, data)
