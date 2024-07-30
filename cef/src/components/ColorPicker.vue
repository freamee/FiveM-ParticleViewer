<template>
    <div class="picker-container">
        <span class="picker-title">{{ title }}</span>
        <Verte picker="square" model="rgb" :menu-position="'top'" :draggable="false" :showHistory="false"
            v-model="localValue">
            <svg>
                <rect x="0" y="0" width="100%" height="100%" />
            </svg>
        </Verte>

        <div class="picker-value">
            {{ currentValue }}
        </div>
    </div>
</template>

<script lang="ts" setup>
import Verte from 'verte-vue3';
import 'verte-vue3/dist/verte.css';
import { computed } from 'vue';

const props = defineProps({
    title: {
        type: String,
        required: true
    },
    currentValue: {
        type: String,
        required: true
    },
});

const emit = defineEmits<{
    (event: 'update:currentValue', payload: string): void;
}>();

const localValue = computed({
    get() {
        return props.currentValue;
    },
    set(value) {
        emit('update:currentValue', value);
    }
})

</script>

<style lang="scss" scoped>
$CONTAINER_BACKGROUND_COLOR: rgb(36, 36, 36);

.picker-container {
    position: relative;
    display: flex;
    flex-direction: column;
    place-items: center;
    gap: 0.5rem;

    .picker-title {
        font-size: .7vw;
        color: white;
    }

    .picker-value {
        background-color: rgba(20, 20, 20, 0.85);
        padding: .35vw;
        border-radius: .25vw;
        font-size: 1.2vh;
        color: white;
    }

    background-color: $CONTAINER_BACKGROUND_COLOR;
    padding: .35vw 0;
    border-radius: .25vw;
}
</style>

<style lang="scss">
$PICKER_BACKGROUND_COLOR: rgb(55, 55, 55);
$PICKER_INPUT_COLOR: rgb(68, 68, 68);

.verte__guide {
    width: 80% !important;
    border: 1px solid white;
    border-radius: 2px;
}

.verte__menu {
    background-color: $PICKER_BACKGROUND_COLOR;
}

.verte__input {
    background-color: $PICKER_INPUT_COLOR;
    color: #fff;
    border-radius: 5px;
}

.verte__model,
.verte__submit {
    color: rgb(220, 220, 220);
    fill: rgb(220, 220, 220);

    &:hover {
        color: white;
        fill: white;
    }
}

.verte__recent {
    background-color: $PICKER_INPUT_COLOR;
    border-radius: 5px;
}

.verte__recent-color {
    background-color: $PICKER_INPUT_COLOR;
}

.verte-picker__slider,
.verte__controller>.slider {
    background-color: $PICKER_INPUT_COLOR;
    padding: 0.2rem;
    border-radius: 5px;
}
</style>
