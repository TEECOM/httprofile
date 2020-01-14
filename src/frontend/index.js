import './assets/styles/main.css';

import { Elm } from './elm/Main.elm';

var app = Elm.Main.init({
  node: document.getElementById('root')
});

app.ports.blurActive.subscribe(function(data) {
  document.activeElement.blur();
});
