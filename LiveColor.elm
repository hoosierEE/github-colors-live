module LiveColor where

import Http
import Signal
import Json.Decode (..)
import Text (asText,plainText)

-- PORTS
port clrs : Signal Value -- (INPUT) result of YAML -> JSON conversion

port yamlReq : Signal String -- (OUTPUT) Http GET the yaml string
port yamlReq =
    let url = Signal.constant "https://rawgit.com/github/linguist/master/lib/linguist/languages.yml"
        res : Signal (Http.Response String)
        res = Http.sendGet url
        decodeResponse : Http.Response String -> String
        decodeResponse result = case result of
            Http.Success msg -> msg
            Http.Waiting -> ""
            Http.Failure _ _ -> ""
    in Signal.map decodeResponse res

-- CONVERSIONS
type alias Language = { color: String }

-- Design the decoders
lang : Decoder Language
lang = object1 Language (oneOf ["color" := string, succeed "#cccccc"])

lang' : Decoder String
lang' = at ["color"] string

lng : Decoder (Value,Language)
lng = object2 (,) value (lang)


-- Err ("expecting an object with field 'color' but got {\"ABAP\":{\"type\": ...
pa s = asText (decodeValue lang' s)

-- Ok ([("xBase",{ color = "#3a4040" }),("wisp",{ color = "#7582D1" ...
pb s = asText (decodeValue (keyValuePairs lang) s)

-- Ok ([("xBase",(<internal structure>,{ color = "#3a4040" })),("wisp",(<internal structure>,{ color = "#7 ...
pc s = asText (decodeValue (keyValuePairs lng) s)

-- display results
main = Signal.map pc clrs

