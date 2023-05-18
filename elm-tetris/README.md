# Elm Tetris
A [Flatris](https://github.com/skidding/flatris) clone in Elm adjusted to VG100 needs.

![](elm-tetris.png)

## Features

* Works with both button and keyboard input
* Powered by [Messenger](https://github.com/linsyking/Messenger)
* Best score saved

## Instructions to run

1. Install elm [elm-lang.org/install](http://elm-lang.org/install)
2. Clone this repo and `cd` into it
3. Run `make`
4. Open `index.html` in the browser

## Architecture

Modules besides the original framework:

- Components/Button/
- Scenes/Main/UILayer/
- Scenes/Main/GameLayer/
- Lib/Tetris/

Changed:

- Lib/LocalStorage/
