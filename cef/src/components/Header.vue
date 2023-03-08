<template>
    <div class="header-parent">
        <MacButtons :is-left="true" />

        <div class="header-name">
            Particle Viewer
        </div>

        <div class="header-logo"></div>
    </div>
</template>

<script lang="ts" setup>
import MacButtons from './MacButtons.vue';

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