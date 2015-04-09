import Text (asText)
import Graphics.Element (..)
import String (indexes,fromChar,toList)
import List (map,head,reverse,indexedMap,foldr)

decimalFromHex : String -> Int
decimalFromHex hexString =
    let xs = reverse <| toList hexString
        vals = map (head << flip indexes "0123456789ABCDEF0123456789abcdef" << fromChar) xs
        powered = indexedMap (\idx val -> (16 ^ idx) * (val % 16)) vals
    in foldr (+) 0 powered

-- decimalFromHex' : String -> Int
-- decimalFromHex' hexString =
--     let xs = toList hexString
--         vals = map (head << flip indexes "0123456789ABCDEF0123456789abcdef" << fromChar) xs
--         powered = indexedMap (\idx val -> (16 ^ idx) * (val % 16)) vals
--     in foldr (+) 0 powered

-- helpers
base num =
    let
        ii = toList "0123456789"
        aa = toList "abcdefghijklmnopqrstuvwxyz"
        aA = toList "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    in if | num < 10 -> ii
          | otherwise -> ii

strFold str = case toList str of
    [] -> "empty"
    _ -> ""


-- tests
dfhs =
    let tests = [ "ff" -- 255
                , "01" -- 1
                , "10" -- 16
                , "100" -- 256
                ]
    in map (asText << decimalFromHex) tests

main = flow down dfhs
