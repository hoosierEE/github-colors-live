module TestJson where

import Text (asText,plainText)
import Json.Decode (..)

type alias Language = { color: String }

-- Design the decoders
lang : Decoder Language
lang = object1 Language (oneOf ["color" := string, succeed "#cccccc"])

-- Example data
testdata0 = """
{
    "Apple":{"color":"#aeaeae"},
    "Orange":{"color":"#abcabc"},
    "Kiwi":{"tartness":7000},
    "Pear":{"color":"#00bb99","tartness":100}
}
"""

print d s = asText (decodeString d s)

-- resFromStr s = getResult (decodeString (keyValuePairs lang) s)
getResult a = case a of
    Ok rs -> rs
    Err s -> s

main = (print (keyValuePairs lang) testdata0)

