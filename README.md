# github-colors-live

[demo](http://hoosieree.github.io/github-colors-live)

the current github language colors, sorted alphabetically and by [hue](https://en.wikipedia.org/wiki/HSL_and_HSV)

Build
-----

1. clone and cd into this repo

        git clone https://github.com/hoosieree/github-colors-live
        cd github-colors-live

2. compile and put the resulting js where our `index.html` knows to look for it

        elm-make LiveColors.elm --output vendor/elm.js

3. start the elm server

        elm-reactor

4. browse to `localhost:8000/index.html` to see the page
