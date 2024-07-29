
<template>
    <Transition enterActiveClass="animate__animated animate__fadeIn animate__faster"
        leaveActiveClass="animate__animated animate__fadeOut animate__faster">

        <div v-if="isOpened" ref="panelRef" class="panel-parent" :style="{
            left: typeof panelX === 'number' ? (panelX + 'px') : '',
            top: typeof panelY === 'number' ? (panelY + 'px') : ''
        }">

            <Header header-name="Particle Viewer" @on-close-click="isOpened = false"
                @mousedown.prevent.left="handleMouseDown" />

            <Search v-model:current-value="searchValue" />

            <div style="display:flex">
                <Button @click="isPlaying = true" :color="isPlaying ? 'green' : ''" name="Play" />
                <Button @click="isPlaying = false" :color="!isPlaying ? 'red' : ''" name="Stop" />
            </div>

            <div class="simple-text">
                Particles are in looped state, some of the particles can not be looped.
            </div>

            <Selector @on-left-clicked="onDictionaryLeft" @on-right-clicked="onDictionaryRight" :current-idx="dictionaryIdx"
                :max-idx="Object.keys(ParticlesJSON).length - 1" :current-name="DictionaryName" name="Dictionary" />

            <Selector :current-name="CurrentParticle" @on-left-clicked="onParticleLeft" @on-right-clicked="onParticleRight"
                :current-idx="particleIdx" :max-idx="DictionaryParticles.length - 1" name="Effect" />

            <Slider v-model:value="particleScale" :min="minScale" :max="maxScale" title="Particle Scale" />

            <ColorPicker v-model:current-value="particleColor" title="Particle Color"></ColorPicker>

            <SearchPanel @on-particle-clicked="({ dictIdx, fxIdx }) => {
                dictionaryIdx = dictIdx;
                particleIdx = fxIdx;
            }" :search-value="searchValue" />

            <EvolutionPanel></EvolutionPanel>

            <div style="margin-top: .5vw;"></div>
        </div>
    </Transition>
</template>

<script lang="ts" setup>
import Search from '../components/Search.vue';
import Header from '../components/Header.vue';
import Selector from '../components/Selector.vue';
import Slider from "../components/Slider.vue";
import Button from '../components/Button.vue';
import ColorPicker from '../components/ColorPicker.vue';
import SearchPanel from "../components/SearchPanel.vue";
import EvolutionPanel from '../components/EvolutionPanel.vue';
import { computed, onMounted, ref, watch } from 'vue';
import ParticlesJSON from "../particles.json";
import { AxiosInstance } from '../plugins/axios.plugin';

const dictionaryIdx = ref(0);
const particleIdx = ref(0);
const particleScale = ref(1.0);
const particleColor = ref('rgba(255, 255, 255, 1)');

const panelRef = ref<HTMLElement>();
const isPlaying = ref(false);
const isOpened = ref(false);
const searchValue = ref("");

const minScale = 0.1;
const maxScale = 15.0;

let isMoving = false;
let offsetX = 0;
let offsetY = 0;

const panelX = ref<number | null>(null);
const panelY = ref<number | null>(null);

onMounted(() => {
    const savedX = localStorage.getItem("panelX");
    const savedY = localStorage.getItem("panelY");

    if (import.meta.env.DEV) {
      isOpened.value = true;
    }

    if (savedX != null && savedY != null) {
        panelX.value = Number(savedX);
        panelY.value = Number(savedY);
    }

    AxiosInstance.post("SET_PARTICLE_DATA_ON_MOUNTED", {
        scale: particleScale.value,
        particleFx: CurrentParticle.value,
        dictionary: DictionaryName.value
    });
});

watch(isPlaying, (newValue) => {
    AxiosInstance.post("SET_PLAYING_STATE", {
        state: newValue
    })
});
watch(isOpened, (newValue) => {
    AxiosInstance.post("SET_CURSOR_STATE", {
        state: newValue
    });

    isPlaying.value = false;
});

watch(particleScale, (newValue) => {
    if (newValue > maxScale) {
        particleScale.value = maxScale;
    }
    else if (newValue < minScale) {
        particleScale.value = minScale;
    }

    AxiosInstance.post("CHANGE_PARTICLE_SCALE", {
        scale: newValue
    })
});

watch(particleColor, (newValue) => {
    const color: { r: number, g: number, b: number, a: number } = { r: 255, g: 255, b: 255, a: 1.0 };
    const pattern = /rgba?\((\d{1,3}),(\d{1,3}),(\d{1,3}),?(?:|(\d{1}\.?\d{0,2}))\)/;
    const result = pattern.exec(newValue)?.map(i => Number(i));

    if (result?.length && result.length >= 4) {
        color.r = result[1] / 255;
        color.g = result[2] / 255;
        color.b = result[3] / 255;
        color.a = isNaN(result[4]) ? 1.0 : result[4];
    }

    AxiosInstance.post("CHANGE_PARTICLE_COLOR", { color });
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

watch(CurrentParticle, (newValue) => {
    AxiosInstance.post("CHANGE_PARTICLE", {
        particleFx: newValue,
        dictionary: DictionaryName.value
    });
});

function onDictionaryLeft() {
    if (dictionaryIdx.value - 1 < 0) return;
    dictionaryIdx.value--;

    particleIdx.value = 0;
}

function onDictionaryRight() {
    if (dictionaryIdx.value + 1 > Object.keys(ParticlesJSON).length - 1) return;
    dictionaryIdx.value++;

    particleIdx.value = 0;
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

window.addEventListener("message", (ev: MessageEvent) => {
    if (ev.data.message = "SET_OPEN_STATE") {
        isOpened.value = ev.data.state;
    }
});

window.addEventListener("keyup", (ev: KeyboardEvent) => {
    const key = ev.key.toLowerCase();

    switch (key) {
        case 'escape':
            isOpened.value = false;
            break;
        case 'q':
            onDictionaryLeft();
            break;
        case 'e':
            onDictionaryRight();
            break;
        case 'arrowleft':
            onParticleLeft();
            break;
        case 'arrowright':
            onParticleRight();
            break;
        case 'arrowup':
            particleScale.value = Number((particleScale.value + 0.1).toFixed(1));
            break;
        case 'arrowdown':
            particleScale.value = Number((particleScale.value - 0.1).toFixed(1));
            break;
    }
});


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

    display: flex;
    flex-direction: column;
    gap: .5vw;
}

.simple-text {
    position: relative;
    width: 100%;
    text-align: center;
    font-size: .7vw;
    color: rgb(166, 166, 166);
}
</style>
