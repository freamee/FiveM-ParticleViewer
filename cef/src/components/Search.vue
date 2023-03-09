<template>
    <div class="search-parent">
        <i class="fa-solid fa-search"></i>
        <input v-model="localValue" placeholder="Search" type="text">
    </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';

const props = defineProps({
    currentValue: {
        type: String,
        required: true
    }
})

const emit = defineEmits<{
    (event: 'update:currentValue', payload: string): void;
}>();

const localValue = ref(props.currentValue);
watch(localValue, (newValue) => {
    emit('update:currentValue', newValue);
});
</script>

<style lang="scss" scoped>
$BACKGROUND_COLOR: rgb(36, 36, 36);
$PLACEHOLDER_COLOR: rgb(75, 75, 75);

.search-parent {
    position: relative;
    width: 100%;
    height: 1.8vw;
    background-color: $BACKGROUND_COLOR;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: .25vw;
    overflow: hidden;

    i {
        text-indent: .5vw;
        color: $PLACEHOLDER_COLOR;
    }

    input {
        flex: 1;
        height: 100%;
        border: 0;
        background-color: transparent;
        outline: 0;
        font-size: .8vw;
        color: rgb(220, 220, 220);
        text-align: left;
        text-indent: .5vw;

        &::placeholder {
            font-size: .8vw;
            color: $PLACEHOLDER_COLOR;
        }
    }
}
</style>