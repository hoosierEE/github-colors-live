# github-colors-live

[demo](http://hoosieree.github.io/github-colors-live)

the current github language colors, sorted alphabetically and by [hue](https://en.wikipedia.org/wiki/HSL_and_HSV)

Build
-----

1. clone and cd into this repo

        git clone https://github.com/hoosieree/github-colors-live
        cd github-colors-live

2. use `elm-package` to download the libraries used by `LiveColors.elm`

        elm-package install

3. compile and put the resulting js where our `index.html` knows to look for it

        elm-make LiveColor.elm --output vendor/elm.js

4. start the elm server

        elm-reactor

5. browse to `localhost:8000/index.html` to see the page
