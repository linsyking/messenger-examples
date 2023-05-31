#!/bin/bash
mkdir -p build
elm make src/Main.elm --output=build/main.js
cp -f public/index.html .
cp -f public/style.css build/style.css
cp -f public/*.js build/
