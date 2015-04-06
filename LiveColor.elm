module LiveColor where

import List
import Http
import Signal
import Json.Decode (..)
import Text (asText,plainText)

-- PORTS
port clrs : Signal Value -- result of YAML -> JSON conversion
port yamlReq : Signal String -- Http GET the yaml string
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

-- extract value from JSON
lv : Decoder (List (String,Value))
lv = keyValuePairs value

-- turn a (String,Value) into a (String,String)
-- TODO

-- get the color, or use a default value
defaultColor : Decoder String
defaultColor = oneOf ["color" := string, succeed "#cccccc"]

-- run the decoder on the incoming value
scene a = asText (decodeValue lv a)

-- display results
main = Signal.map scene clrs

