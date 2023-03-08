
<template>
    <div ref="panelRef" class="panel-parent" :style="{
        left: typeof panelX === 'number' ? (panelX + 'px') : '',
        top: typeof panelY === 'number' ? (panelY + 'px') : ''
    }">
        <Header @mousedown.prevent.left="handleMouseDown" />
        <div style="margin-top: 1vw; margin-bottom:.5vw;"></div>
        <Search />
        <div style="margin-top: 1vw; margin-bottom:.5vw;"></div>
        <Selector @on-left-clicked="onDictionaryLeft" @on-right-clicked="onDictionaryRight" :current-idx="dictionaryIdx"
            :max-idx="Object.keys(ParticlesJSON).length - 1" :current-name="DictionaryName" name="Dictionary" />
        <div style="margin-bottom:.5vw;"></div>
        <Selector :current-name="CurrentParticle" @on-left-clicked="onParticleLeft" @on-right-clicked="onParticleRight"
            :current-idx="particleIdx" :max-idx="DictionaryParticles.length - 1" name="Effect" />
    </div>
</template>

<script lang="ts" setup>
import Search from '../components/Search.vue';
import Header from '../components/Header.vue';
import Selector from '../components/Selector.vue';
import { computed, onMounted, ref, watch } from 'vue';
import ParticlesJSON from "../particles.json";

const dictionaryIdx = ref(0);
const particleIdx = ref(0);
const panelRef = ref<HTMLElement>();

let isMoving = false;
let offsetX = 0;
let offsetY = 0;

const panelX = ref<number | null>(null);
const panelY = ref<number | null>(null);

onMounted(() => {
    const savedX = localStorage.getItem("panelX");
    const savedY = localStorage.getItem("panelY");

    if (savedX != null && savedY != null) {
        panelX.value = Number(savedX);
        panelY.value = Number(savedY);
    }
});

watch(particleIdx, (newParticle) => {

})
watch(dictionaryIdx, (newDict) => {
    particleIdx.value = 0;
});

const DictionaryName = computed(() => {
    return Object.keys(ParticlesJSON)[dictionaryIdx.value]
});

const DictionaryParticles = computed<string[]>(() => {
    // @ts-ignore
    return ParticlesJSON[DictionaryName.value];
});

const CurrentParticle = computed(() => {
    return DictionaryParticles.value[particleIdx.value];
});

function onDictionaryLeft() {
    if (dictionaryIdx.value - 1 < 0) return;
    dictionaryIdx.value--;
}

function onDictionaryRight() {
    if (dictionaryIdx.value + 1 > Object.keys(ParticlesJSON).length - 1) return;
    dictionaryIdx.value++;
}

function onParticleLeft() {
    if (particleIdx.value - 1 < 0) return;
    particleIdx.value--;
}

function onParticleRight() {
    if (particleIdx.value + 1 > DictionaryParticles.value.length - 1) return;
    particleIdx.value++;
}

function handleMouseDown(ev: MouseEvent) {
    if (isMoving) return;

    isMoving = true;

    window.addEventListener("mouseup", handleMouseUp);
    window.addEventListener("mousemove", handleMouseMove);

    const element = panelRef.value;
    if (element) {
        offsetX = element.offsetLeft + element.offsetWidth - ev.clientX;
        offsetY = element.offsetTop + element.offsetHeight - ev.clientY;
    }
}

function handleMouseUp() {
    isMoving = false;
    window.removeEventListener("mouseup", handleMouseUp);
    window.removeEventListener("mousemove", handleMouseMove);

    if (typeof panelX.value === 'number' && typeof panelY.value === 'number') {
        localStorage.setItem("panelX", panelX.value.toString());
        localStorage.setItem("panelY", panelY.value.toString());
    }
}

function handleMouseMove(ev: MouseEvent) {
    if (!isMoving) return;

    const element = panelRef.value;
    if (element) {
        panelX.value = ev.clientX + offsetX - element.offsetWidth;
        panelY.value = ev.clientY + offsetY - element.offsetHeight;
    }
}

</script>

<style lang="scss" scoped>
$BACKGROUND_COLOR: rgb(28, 28, 28);
$PANEL_WIDTH: 13vw;

.panel-parent {
    position: absolute;
    width: $PANEL_WIDTH;
    background-color: $BACKGROUND_COLOR;
    border-radius: .25vw;
    box-shadow: 0 0 .15vw black;
    padding: .85vw;
    top: 30%;
    left: 5%;
}
</style>