<template>
    <Panel />
</template>

<script lang="ts" setup>
import { onMounted } from "vue";
import { AxiosInstance } from "./plugins/axios.plugin";
import Panel from "./views/Panel.vue";

onMounted(() => {
    AxiosInstance.post("CEF_LOADED");
});

</script>