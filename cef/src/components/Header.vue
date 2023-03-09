<template>
    <div class="header-parent">
        <MacButtons v-if="hasButtons" @on-close-click="emit('onCloseClick')" :is-left="true" />

        <div class="header-name">
            {{ headerName }}
        </div>

        <div v-if="hasLogo" class="header-logo"></div>
    </div>
</template>

<script lang="ts" setup>
import MacButtons from './MacButtons.vue';

const emit = defineEmits(["onCloseClick"])

defineProps({
    headerName: {
        type: String,
        required: true
    },
    hasButtons: {
        type: Boolean,
        default: true
    },
    hasLogo: {
        type: Boolean,
        default: true
    }
})

</script>

<style lang="scss" scoped>
.header-parent {
    position: relative;
    width: 100%;

    .header-name {
        font-size: .9vw;
        font-weight: bold;
        color: rgb(220, 220, 220);
    }

    .header-logo {
        position: absolute;
        top: 0;
        right: 0;
        width: 2.5vw;
        height: 2.5vw;
        background-image: url(/avlogo_nobg.png);
        background-position: center;
        background-size: contain;
        background-repeat: no-repeat;
    }
}
</style>