module LiveColor where

import Math.Vector3 as Vec
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
port clrs : Signal (List (String, Maybe String)) -- (INPUT) result from YAML->JSON->filtering
port yamlReq : Signal String -- (OUTPUT) Http SEND GET the yaml string
port yamlReq =
    let
        url = Signal.constant "https://rawgit.com/github/linguist/master/lib/linguist/languages.yml"
        res : Signal (Http.Response String)
        res = Http.sendGet url
        dResponse : Http.Response String -> String
        dResponse result = case result of
            Http.Success msg -> msg
            Http.Waiting -> ""
            Http.Failure _ _ -> ""
    in Signal.map dResponse res

------------
-- RENDER --
------------
scene : (Int,Int) -> List (String, Maybe String) -> Element
scene (w,h) ls =
    let
        title = (width w << T.centered << T.typeface ["helvetica neue","helvetica","serif"] << T.height 40 << T.fromString) "Github Language Colors, Sorted"
        byAlp : List (Element, { alpha : Float, hue : Float, lightness : Float, saturation : Float })
        byAlp = List.map (\(a,b) -> (txtFn a, clrFn b)) ls
        txtFn = T.centered << T.height 18 << T.fromString
        clrFn c = case c of
            Just c -> Color.toHsl <| rgbFromCss c
            Nothing -> Color.toHsl <| rgbFromCss "#fff"
        stylize lst = List.map boxed lst
        fds (h,t) = flow down [txtFn h, flow down <| stylize t]
        -- dHue (a,b) = Vec.distance (Vec.vec3 a.hue a.saturation a.lightness) (Vec.fromTuple b)
        byHue = List.sortBy (.hue << snd) byAlp
        bySat = List.sortBy (.saturation << snd) byAlp
        byLig = List.sortBy (.lightness << snd) byAlp
        cols = [("alphabetical",byAlp),("by hue",byHue),("saturation",bySat),("lightness",byLig)]
        boxed (txt,clr) =
            let mw = w // List.length cols
                c = Color.hsl clr.hue clr.saturation clr.lightness
            in color c <| container mw 60 middle (width mw <| txt)
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

