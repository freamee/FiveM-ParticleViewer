import { createPinia } from 'pinia';
import { createApp, ref } from 'vue'
import App from './App.vue'
import "./global.scss";
import $ from "jquery";
import 'animate.css';
import "./slider.css"

createApp(App)
    .use(createPinia())
    .mount('#app');

if (import.meta.env.DEV) {
    $("body").css({
        'backgroundColor': 'grey'
    })
}