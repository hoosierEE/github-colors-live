module LiveColor where

import Http
import Graphics.Element (flow,down)
import Signal
import List
import Array (..)
import Text (asText,plainText)

-- PORTS
-- port clrs : Signal (Array(Array(String, Maybe String)))-- (INPUT) result of YAML -> JSON conversion and filtering.
port clrs : Signal (Array(List(String, Maybe String)))-- (INPUT) result of YAML -> JSON conversion and filtering.

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

scene a = flow down (List.map (\c -> asText c) a)

-- display results
main = Signal.map asText clrs

