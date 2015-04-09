module Rebase (decimalFromHex) where
-- module Hex where

import String (indexes,fromChar,toList)
import List (map,head,reverse,indexedMap,foldr)
-- import Text (asText)
-- main = asText <| decimalFromHex "010"

decimalFromHex : String -> Int
decimalFromHex hexString =
    let xs = toList hexString
        vals = map (head << flip indexes "0123456789ABCDEF0123456789abcdef" << fromChar) xs
        powered = indexedMap (\idx val -> (16 ^ idx) * (val % 16)) vals
     in foldr (+) 0 powered

-- hexFromDecimal : Int -> String
-- hexFromDecimal decimal =
--     toString decimal
