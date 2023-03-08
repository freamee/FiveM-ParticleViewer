<template>
    <button @click.prevent.left="$emit('click')" :class="'button-parent ' + color">{{ name }}</button>
</template>

<script lang="ts" setup>
const props = defineProps({
    name: {
        type: String,
        required: true
    },
    color: {
        type: String,
        required: false
    }
})

const emit = defineEmits(["click"])
</script>

<style lang="scss" scoped>
button {
    width: 100%;
    color: white;
    font-size: .7vw;
    border: .1vw solid rgb(66, 66, 66);
    padding: .35vw .5vw;
    border-radius: .25vw;
    margin: .25vw;
    flex: 1;
    text-align: center;
    background: linear-gradient(180deg, rgba(100, 100, 100, 0.2), rgba(65, 65, 65, 0.2));
    transition: ease();
    transition-duration: .15s;
    font-weight: bold;

    &:hover {
        border: .1vw solid lightgreen;
    }

    &.green {
        background-color: lightgreen;
    }

    &.red {
        background-color: red;
    }
}
</style>