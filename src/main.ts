import { createApp } from "vue";
import App from "./App.vue";
import "./style.css";

import PrimeVue from "primevue/config";
import Drawer from "primevue/drawer";

import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.bundle.min.js";

const app = createApp(App);
app.use(PrimeVue);
app.component("Drawer", Drawer);
app.mount("#app");
