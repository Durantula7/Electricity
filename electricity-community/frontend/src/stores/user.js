import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const userId = ref(localStorage.getItem('userId') || '')
  const username = ref(localStorage.getItem('username') || '')
  const realName = ref(localStorage.getItem('realName') || '')
  const roleId = ref(localStorage.getItem('roleId') || '')

  const setUser = (info) => {
    userId.value = info.userId
    username.value = info.username
    realName.value = info.realName || info.username
    roleId.value = info.roleId
    localStorage.setItem('token', info.token)
    localStorage.setItem('userId', info.userId)
    localStorage.setItem('username', info.username)
    localStorage.setItem('realName', info.realName || info.username)
    localStorage.setItem('roleId', info.roleId)
  }

  const clearUser = () => {
    userId.value = ''
    username.value = ''
    realName.value = ''
    roleId.value = ''
    localStorage.clear()
  }

  return { userId, username, realName, roleId, setUser, clearUser }
})
