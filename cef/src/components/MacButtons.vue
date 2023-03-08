<template>
    <div class="mac-buttons-parent">

        <div @click.left.prevent="onClick" @mouseenter="mouseEnter" class="close-button" :style="{
            left: isLeft ? '0' : '',
            right: !isLeft ? '0' : ''
        }">
            <i>X</i>
        </div>

    </div>
</template>

<script lang="ts" setup>
import { declineSound, hoverSound } from '../plugins/audio.plugin';

const emit = defineEmits(["click"])

defineProps({
    isLeft: {
        type: Boolean,
        default: false
    }
})

function mouseEnter() {
    hoverSound();
}

function onClick() {
    declineSound();

    emit("click");
}

</script>


<style lang="scss" scoped>
.mac-buttons-parent {
    position: relative;
    width: 100%;
    height: 1.5vw;

    .close-button {
        position: absolute;
        background: red;
        width: .8vw;
        height: .8vw;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;

        &:hover {
            i {
                opacity: 1;
            }
        }

        i {
            color: white;
            opacity: 0;
            font-size: .5vw;
        }
    }
}
</style>