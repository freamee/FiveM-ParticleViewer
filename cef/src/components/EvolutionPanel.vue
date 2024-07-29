<template>
    <div class="evolution-container">
        <span class="title">Evolution settings</span>

        <Select v-model:current-value="currentEvolution" labelKey="label" valueKey="value" :items="evolutionOptions"></Select>

        <Slider v-model:value="currentValue" :min="0.0" :max="1.0" />
    </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import Select from './Select.vue';
import Slider from './Slider.vue';
import { AxiosInstance } from '../plugins/axios.plugin';

export type EvolutionOption = { label: string, value: string, slider?: number };

const evolutionOptions: EvolutionOption[] = [
    { label: 'Scale X', value: 'ScaleX' },
    { label: 'Scale Y', value: 'ScaleY' },
    { label: 'Intensity', value: 'Intensity' },
    { label: 'Intensity (lowercase)', value: 'intensity' },
    { label: 'Size', value: 'size' },
    { label: 'Radius', value: 'radius' },
    { label: 'Smoke', value: 'smoke' },
    { label: 'Speed', value: 'speed' },
    { label: 'Fade', value: 'fade' },
    { label: 'Heat', value: 'heat' },
    { label: 'Power', value: 'power' },
    { label: 'Fire', value: 'fire' },
    { label: 'Flame', value: 'flame' },
    { label: 'Group', value: 'group' },
    { label: 'Light Intensity', value: 'light_intensity' },
    { label: 'Smoke Fade', value: 'smoke_fade' },
    { label: 'Width', value: 'width' },
    { label: 'Length', value: 'length' },
    { label: 'Wings', value: 'wings' },
    { label: 'Damage Smoke', value: 'damage_smoke' },
    { label: 'Damage Fire', value: 'damage_fire' },
    { label: 'Damage', value: 'damage' },
    { label: 'Strength', value: 'strength' },
    { label: 'level', value: 'level' },
    { label: 'Fill', value: 'fill' },
    { label: 'Open', value: 'open' },
    { label: 'Spread Back', value: 'spread_back' },
    { label: 'Spread Length', value: 'spread_length' },
    { label: 'DieOff', value: 'DieOff' },
    { label: 'DIE_OFF', value: 'DIE_OFF' },
];

const evolutionMap = ref(evolutionOptions.reduce((map, item) => {
    map[item.value] = { ...item, slider: 0.5 };
    return map;
}, {} as Record<string, Required<EvolutionOption>>));

const currentEvolution = ref(evolutionOptions[0].value);
const currentValue = ref(0.5);

watch(currentEvolution, (newValue) => {
    currentValue.value = evolutionMap.value[newValue].slider;
});

watch(currentValue, (newValue) => {
    evolutionMap.value[currentEvolution.value].slider = newValue;

    AxiosInstance.post("CHANGE_EVOLUTION_PROPERTY", {
        name: currentEvolution.value,
        value: newValue
    });
});
</script>

<style lang="scss" scoped>
$CONTAINER_BACKGROUND_COLOR: rgb(36, 36, 36);

.evolution-container {
    display: flex;
    flex-direction: column;
    place-items: center;

    padding: .35vw 1rem;
    border-radius: .25vw;

    background-color: $CONTAINER_BACKGROUND_COLOR;
    color: white;

    gap: 0.5rem;

    .title {
        font-size: 0.7vw;
    }
}
</style>
