import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'

import HomeVue from '~/pages/home/Index.vue'
import AboutVue from '~/pages/about/Index.vue'

const routes: RouteRecordRaw[] = [
  {
    name: 'home',
    path: '/',
    component: HomeVue
  },
  {
    name: 'about',
    path: '/about',
    component: AboutVue
  }
]

export const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

declare module 'vue-router' {}
