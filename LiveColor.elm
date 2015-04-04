module LiveColor where

import Http
import Signal (..)
import Json.Decode (Decoder,string,Value)
import Text (asText)

-- send the result of an Http request over to the JS for processing
port convertYaml : Signal String
port convertYaml =
    let url = constant "https://rawgit.com/github/linguist/master/lib/linguist/languages.yml"
        res : Signal (Http.Response String)
        res = Http.sendGet url
        decodeResponse : Http.Response String -> String
        decodeResponse result = case result of
            Http.Success msg -> msg
            Http.Waiting -> ""
            Http.Failure _ _ -> ""
    in decodeResponse <~ res

-- get JSON after some javascript library converts it from Yaml for us
port clrs : Signal Value

-- Extract a List(String, maybe String) from a JSON object


-- display results
main = asText <~ clrs

