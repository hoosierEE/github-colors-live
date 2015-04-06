module LiveColor where

import Http
import Signal
import Text (asText)

-- PORTS
-- input
port clrs : Signal (List (List (Maybe String))) -- result of YAML -> JSON conversion and filtering.

-- output
port yamlReq : Signal String -- Http SEND GET the yaml string
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

-- display results
main = Signal.map asText clrs

