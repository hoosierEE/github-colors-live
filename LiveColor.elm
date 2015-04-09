module LiveColor where

import Color
import Graphics.Element (..)
import Graphics.Collage (..)
import Rebase
import Http
import List
import Maybe
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
        txtFn t = T.justified <| T.fromString t
        clrFn c = case c of
            Just c -> rgbFromCss c
            Nothing -> rgbFromCss "#ccc"
        boxed (txt,clr) =
            let mw = max 250 (w//3)
            in container mw 30 middle (width mw <| txtFn txt) |> color (clrFn clr)
        doAll lst = List.map boxed lst
    in flow down <| doAll ls

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

