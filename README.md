# github-colors-live
show the current github language colors

Build
-----

1. clone and cd into this repo

        git clone https://github.com/hoosieree/github-colors-live
        cd github-colors-live

2. use `elm-package` to download the libraries used by `LiveColors.elm`

        elm-package install

3. compile and put the resulting js where our `index.html` knows to look for it

        elm-make LiveColors.elm --output vendor/elm.js

4. start the elm server

        elm-reactor

5. browse to `localhost:8000/index.html` to see the page
