module ColorTest where

import Color
import Graphics.Element (..)
import Graphics.Collage (..)
import Rebase
import Http
import List
import Signal
import String
import Text as T
import Window

------------
-- PORTS --
------------
clrs : Signal (List (String, Maybe String)) -- (INPUT) result from YAML->JSON->filtering
clrs = Signal.constant
    [ ("Antlr",Just "9dc3ff")
    , ("ActionScript",Just "#882B0F")
    , ("Clojure",Just "#db5855")
    , ("J",Just "#2d8abd")
    , ("APL",Just "#8a0707")
    ]

------------
-- RENDER --
------------
scene : (Int,Int) -> List (String, Maybe String) -> Element
scene (w,h) ls =
    let
        title = (width w << T.centered << T.typeface ["helvetica","serif"] << T.height 40 << T.fromString) "Github Language Colors, Sorted"
        txtFn = T.centered << T.height 18 << T.fromString
        clrFn c = case c of
            Just c -> Color.toRgb <| rgbFromCss c
            Nothing -> Color.toRgb <| rgbFromCss "#ccc"
        stylize lst = List.map boxed lst
        fds t = flow down <| stylize t
        -- sorted lists
        byAlp = List.map (\(a,b) -> (txtFn a, clrFn b)) ls
        byHue = List.sortBy (.red << snd) byAlp
        bySat = List.sortBy (.green << snd) byAlp
        byLig = List.sortBy (.blue << snd) byAlp
        cols = [byAlp,byHue,bySat,byLig]
        boxed (txt,clr) =
            let mw = w // List.length cols
                c = Color.rgb clr.red clr.green clr.blue
            in width mw <| color c <| container mw 60 middle txt
    in flow down [title, flow right <| List.map fds cols]

------------
-- WIRING --
------------
main = Signal.map2 scene Window.dimensions clrs

---------------
-- UTILITIES --
---------------

-- converts #rgb or #rrggbb (hexColor) into (r,g,b) (integers)
rgbFromCss : String -> Color.Color
rgbFromCss cssColorString =
    let hexColor = if String.left 1 cssColorString == "#"
                   then String.dropLeft 1 cssColorString -- drop the "#"
                   else cssColorString
        str =
            if String.length hexColor == 3 then -- (r,g,b) -> (rr,gg,bb)
               let dub ids = String.concat <| List.map (\(a,b) -> String.repeat 2 <| String.slice a b hexColor) ids
               in dub [(0,1),(1,2),(2,3)]
            else hexColor
        dfh (a,b) = Rebase.decimalFromHex <| String.slice a b str
        rgbIndexes = [(0,2),(2,4),(4,6)]
        [r,g,b] = List.map dfh rgbIndexes
    in Color.rgb r g b

