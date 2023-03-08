export function playAudio(path: string, volume: number = 0.025) {
    const d = new Audio(path);
    d.volume = volume;
    d.play();
}

export function hoverSound(volume: number = 0.1) {
    playAudio("sfx/hover.mp3", volume);
}

export function selectSound(volume: number = 0.1) {
    playAudio("sfx/select.mp3", volume);
}

export function declineSound(volume: number = 0.1) {
    playAudio("sfx/gtadecline.wav", volume);
}