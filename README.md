# github-colors-live
show the current github language colors

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
