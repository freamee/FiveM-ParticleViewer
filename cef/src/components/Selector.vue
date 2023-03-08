<template>
    <div class="selector-parent">
        <i @click.prevent.left="emit('onLeftClicked')" class="fa-solid fa-chevron-left"></i>

        <div class="selector-column-child">
            <div class="selector-name">[ {{ name }} ]</div>
            <div class="selector-count">{{ currentIdx }} / {{ maxIdx }}</div>
            <Transition leaveActiveClass="animate__animated animate__fadeOutRight animate__faster"
                enterActiveClass="animate__animated animate__fadeInLeft animate__faster" mode="out-in">
                <div class="selector-current" :key="currentName">{{ currentName }}</div>
            </Transition>
        </div>

        <i @click.prevent.left="emit('onRightClicked')" class="fa-solid fa-chevron-right"></i>
    </div>
</template>

<script lang="ts" setup>
const props = defineProps({
    name: {
        type: String,
        required: true
    },
    currentIdx: {
        type: Number,
        required: true
    },
    maxIdx: {
        type: Number,
        required: true
    },
    currentName: {
        type: String,
        required: true
    }
})

const emit = defineEmits<{
    (e: 'onLeftClicked'): void
    (e: 'onRightClicked'): void
}>();

</script>

<style lang="scss" scoped>
$BACKGROUND_COLOR: rgb(36, 36, 36);

.selector-parent {
    position: relative;
    width: 100%;
    background-color: $BACKGROUND_COLOR;
    border-radius: .25vw;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 4.5vw;

    .fa-solid {
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100%;
        background-color: rgb(45, 45, 45);
        font-size: .85vw;
        color: rgb(155, 155, 155);
        width: 10%;
        border-radius: inherit;

        &:hover {
            background-color: rgb(66, 66, 66);
            color: white;
        }
    }

    .selector-column-child {
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        flex: 1;
        text-align: center;
        word-break: break-all;

        .selector-name {
            font-size: .7vw;
            color: rgb(220, 220, 220);
            font-weight: bold;
            margin: .2vw 0;
        }

        .selector-count {
            font-size: .7vw;
            color: rgb(150, 150, 150);
            margin: .2vw 0;
        }

        .selector-current {
            font-size: .7vw;
            color: rgb(175, 175, 175);
            margin: .2vw 0;
        }
    }
}
</style>