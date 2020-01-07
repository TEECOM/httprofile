import './assets/styles/main.css';

import { Elm } from './elm/Main.elm';

Elm.Main.init({
  node: document.getElementById('root')
});

document.body.classList.add(
  "bg-gray-900",
  "antialiased",
  "font-sans",
  "text-white"
);
