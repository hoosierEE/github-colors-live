module LiveColor where

import Char
import Color
import Graphics.Element (..)
import Graphics.Collage (..)
import Http
import List
import Maybe
import Signal
import String
import Text (asText,plainText)

------------
-- PORTS --
------------
port clrs : Signal (List(String,Maybe String)) -- (INPUT) result from YAML->JSON->filtering
port yamlReq : Signal String -- (OUTPUT) Http SEND GET the yaml string
port yamlReq =
    let url = Signal.constant "https://rawgit.com/github/linguist/master/lib/linguist/languages.yml"
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
scene : List(String,Maybe String) -> Element
scene ls =
    let
        txtFn a b = color Color.white <| plainText <| a
        clrFn a = case a of
            Just a -> rgbFromCss a
            Nothing -> rgbFromCss "#ccc"
        boxed (txt,clr) =
            container 300 30 middle (txtFn txt clr) |> color (clrFn clr)
        --doBoth tpl = (txtFn tpl) `beside` (clrFn tpl)
        doAll lst = List.map (\tpl -> boxed tpl) lst
    in flow down <| doAll ls

------------
-- WIRING --
------------
main = Signal.map scene clrs

---------------
-- UTILITIES --
---------------
-- hex to decimal
fromHex : String -> Int
fromHex x =
    let cs = String.toList <| String.toLower x
        vals = List.map (\c -> (String.indexes (String.fromChar c) "0123456789abcdef")) cs
        valList = List.concat <| List.reverse vals
        indexedVals = List.reverse <| List.indexedMap (\idx val -> 16^idx * val) valList
    in List.foldr (+) 0 indexedVals

-- CSS colors typically come in one of two formats, #rrggbb or #rgb
-- browsers do this: #123 becomes #112233
-- Let's convert that mess into a lovely (rr,gg,bb) color!
rgbFromCss : String -> Color.Color
rgbFromCss cssColorString =
    let noHastag = String.dropLeft 1 cssColorString -- drop the "#"
        str = if String.length noHastag == 3 then -- (r,g,b) -> (rr,gg,bb)
                String.concat <| List.map (\n-> (String.repeat 2 n))
                [ String.left 1 noHastag -- red
                , String.left 1 <| String.right 2 noHastag -- green
                , String.right 1 noHastag -- blue
                ]
             else noHastag
        (r,g,b) = (fromHex <| String.slice 0 2 str, fromHex <| String.slice 2 4 str, fromHex <| String.slice 4 6 str)
    in Color.rgb r g b

