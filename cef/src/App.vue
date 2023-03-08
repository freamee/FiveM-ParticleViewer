<template></template>

<script lang="ts" setup>
import { onMounted } from "vue";
import { AxiosInstance } from "./plugins/axios.plugin";

onMounted(() => {
    AxiosInstance.post("CEF_LOADED");
});

</script>