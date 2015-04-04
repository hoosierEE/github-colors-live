module LiveColor where

import Http
import Signal (..)
import Json.Decode (..)
import Text (asText)

-- PORTS
port clrs : Signal Value -- result of YAML -> JSON conversion
-- send the result of an Http request over to the JS for processing
port yamlReq : Signal String
port yamlReq =
    let url = constant "https://rawgit.com/github/linguist/master/lib/linguist/languages.yml"
        res : Signal (Http.Response String)
        res = Http.sendGet url
        decodeResponse : Http.Response String -> String
        decodeResponse result = case result of
            Http.Success msg -> msg
            Http.Waiting -> ""
            Http.Failure _ _ -> ""
    in decodeResponse <~ res

-- CONVERSIONS
-- The values we care about are Language Name and Color.  Color might be absent,
-- and for now we'll treat both as strings.  Later we can conver the (hex) color
-- string to an Elm color.
type alias LC = { lang : String
                , colr : Maybe String
                }

-- extract value from JSON
-- lc : Decoder LC
-- lc =
--     object2 LC
--     ("lang" := string)
--     (maybe ("colr" := string))
lc : Decoder (List (String, Value))
lc = keyValuePairs value


-- run the decoder on the incoming value
scene a = decodeValue lc a

-- display results
main = asText <~ (scene <~ clrs)

