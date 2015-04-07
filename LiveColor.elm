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
import Text (asText)

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
scene ls =
    let txtFn txt = asText <| fst txt
        clrFn clr = asText <| rgbFromCss <| Maybe.withDefault "#ccc" (snd clr)
        --boxed (txt,clr) = flow outward [txtFn txt, spacer 30 30 |> clrFn]
        doBoth tpl = (txtFn tpl) `beside` (clrFn tpl)
        doAll lst = List.map (\tpl -> doBoth tpl) lst
    in flow down (doAll ls)

------------
-- WIRING --
------------
main = Signal.map scene clrs



---------------
-- UTILITIES --
---------------
-- hex to decimal
fromHex x =
    let i = (String.indexes x "0123456789abcdef0123456789ABCDEF")
        i' = List.map (\x -> x `rem` 16) i
    in List.foldr (+) 0 <| List.indexedMap (\a b -> 2^a * b) i'

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
        (r,g,b) = (fromHex <| String.slice 0 1 str, fromHex <| String.slice 2 3 str, fromHex <| String.slice 4 5 str)
    in Color.rgb r g b

