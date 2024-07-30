<template>
    <select v-model="localValue" class="select-input">
        <option v-for="item in props.items" :value="item[valueKey]">{{ item[labelKey] }}</option>
    </select>
</template>

<script lang="ts" setup>
import { computed } from 'vue';

const props = defineProps<{
    labelKey: string;
    valueKey: string;
    items: Record<string, any>[],
    currentValue: any
}>();

const emit = defineEmits<{
    (event: 'update:currentValue', payload: any): void;
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
$CONTAINER_BACKGROUND_COLOR: rgb(58, 58, 58);

.select-input {
    font-family: numans, sans-serif;
    display: inline-block;
    background-color: $CONTAINER_BACKGROUND_COLOR;
    color: white;
    border: none;
    border-radius: 5px;

    min-width: 6rem;
    width: 100%;
    height: 1.75vw;
    padding: 0.2rem;
}
</style>
