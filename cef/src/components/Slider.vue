<template>
    <div class="slider-parent">
        <div class="slider-name">Particle Scale</div>

        <div class="slider-content">
            <VueSlider width="90%" height="0.4vw" tooltip="none" :adsorb="true" :interval="0.1" :max="15" :min="0.1"
                class="slider" v-model="localValue" />
        </div>

        <input type="number" v-model="localValue">
    </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import VueSlider from 'vue-3-slider-component'

const props = defineProps({
    minValue: {
        type: Number,
        required: true
    },
    maxValue: {
        type: Number,
        required: true
    },
    currentValue: {
        type: Number,
        required: true
    }
})

const emit = defineEmits<{
    (event: 'update:currentValue', payload: number): void;
}>();

const localValue = ref(props.currentValue);
watch(localValue, (newValue) => {
    emit('update:currentValue', newValue);
});

</script>

<style lang="scss" scoped>
$BACKGROUND_COLOR: rgb(36, 36, 36);

.slider-parent {
    position: relative;
    width: 100%;
    background-color: $BACKGROUND_COLOR;
    border-radius: .25vw;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: .35vw 0;

    .slider-name {
        font-size: .7vw;
        color: white;
    }

    .slider-content {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        height: 2vw;
    }

    input {
        position: relative;
        width: 40%;
        border: 0;
        background: transparent;
        outline: 0;
        font-size: .75vw;
        border-radius: 0.15vw;
        color: rgb(220, 220, 220);
        text-align: center;
        background: rgba(20, 20, 20, 0.85);
        padding: 0.15vw 0;

        &::placeholder {
            color: rgb(120, 120, 120);
            font-size: 0.7vw;
        }

        &::-webkit-inner-spin-button,
        &::-webkit-outer-spin-button {
            -webkit-appearance: none;
        }
    }
}
</style>