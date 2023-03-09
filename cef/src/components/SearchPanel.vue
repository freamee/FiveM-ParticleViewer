<template>
    <Transition enterActiveClass="animate__animated animate__fadeIn animate__faster"
        leaveActiveClass="animate__animated animate__fadeOut animate__faster">
        <div class="search-panel" v-if="Object.keys(foundEntries).length > 0">
            <Header :has-buttons="false" :has-logo="false" :header-name="`Searches (${foundAmount})`" />

            <div style="margin-top: .5vw; margin-bottom:.5vw;"></div>

            <div class="search-container">
                <div class="search-entry" v-for="(value, dictionaryName) in foundEntries">
                    <div class="dictionary-name">{{ dictionaryName }}</div>
                    <div @click="emit('onParticleClicked', { fxIdx: a.fxIdx, dictIdx: a.dictIdx })" class="fx-name"
                        v-for="a in value">
                        {{ a.fxName }}
                    </div>
                </div>
            </div>
        </div>
    </Transition>
</template>

<script lang="ts" setup>
import Header from './Header.vue';
import ParticlesJSON from "../particles.json";
import { computed, ref } from 'vue';

const props = defineProps({
    searchValue: {
        type: String,
        required: true
    }
})

const emit = defineEmits<{
    (event: 'onParticleClicked', payload: { fxIdx: number; dictIdx: number; }): void;
}>();

const foundAmount = ref(0);

const foundEntries = computed(() => {
    let found: { [dictionary: string]: { dictIdx: number; fxIdx: number; fxName: string; }[] } = {};

    let counter = 0;

    if (props.searchValue.length > 0) {
        Object.entries(ParticlesJSON).forEach((entry, dictionaryIndex) => {
            const [key, value] = entry;

            value.forEach((fxName, fxIdx) => {
                if (fxName.includes(props.searchValue)) {
                    if (typeof found[key] != 'object') {
                        found[key] = [];
                    }

                    counter++;

                    found[key].push({
                        dictIdx: dictionaryIndex,
                        fxIdx: fxIdx,
                        fxName: fxName
                    })
                }
            });
        });
    }

    foundAmount.value = counter;

    return found;
});
</script>

<style lang="scss" scoped>
$BACKGROUND_COLOR: rgb(28, 28, 28);

.search-panel {
    position: absolute;
    background-color: $BACKGROUND_COLOR;
    top: 0;
    left: 15.5vw;
    border-radius: .25vw;
    box-shadow: 0 0 .15vw black;
    padding: .85vw;
    max-height: 90%;

    .search-container {
        position: relative;
        width: 100%;
        overflow: auto;
        height: 22vw;

        .search-entry {

            .dictionary-name {
                color: rgb(220, 220, 220);
                font-weight: bold;
                font-size: .9vw;
                padding: .25vw 0;
            }

            .fx-name {
                color: rgb(175, 175, 175);
                font-size: .65vw;
                background-color: rgb(40, 40, 40);
                margin: .35vw 0;
                padding: .25vw .5vw;
                border-radius: .25vw;

                &:hover {
                    background-color: rgb(60, 60, 60);
                    color: rgb(220, 220, 220);
                }
            }
        }
    }
}
</style>