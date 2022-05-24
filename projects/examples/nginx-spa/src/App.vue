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
  <p>{{ $CONFIG.API_URI }}</p>
  <router-view></router-view>
</template>

<style></style>
