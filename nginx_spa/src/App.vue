<script setup lang="ts"></script>

<template>
  <ul>
    <li>
      <RouterLink :to="{ name: 'home' }">Home</RouterLink>
    </li>
    <li>
      <RouterLink :to="{ name: 'about' }">About</RouterLink>
    </li>
  </ul>
  <router-view></router-view>
</template>

<style></style>
