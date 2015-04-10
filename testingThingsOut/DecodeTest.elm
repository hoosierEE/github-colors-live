import Text (asText)
import Json.Decode as Dec
import Json.Decode ((:=),Decoder)
import List
import Graphics.Element (Element)

type alias GHLang = { language : String, color : Maybe String }
type alias GHLangList = List GHLang

-- jsonString : String
jsonString =
    """{ "AGDA": { "property1":"value", "property2":1, "color":"#abcabc" },
    "APL": { "property1": "value", "property2":"value","color":"#123123"},
    "Colorless-Language-X": {"property1":"value","property2":"value"},
    "Zephyr": { "property1": "value", "property2": "value", "color": "#495969" }
    }"""


-- ghLangListDec : Decoder GHLangList
ghLangListDec = Dec.keyValuePairs (Dec.maybe ("color" := Dec.string)) -- |> Dec.map (List.map (uncurry GHLang))


main : Element
main =
    asText  (Dec.decodeString ghLangListDec jsonString)

