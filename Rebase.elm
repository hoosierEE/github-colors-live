module Rebase (decimalFromHex) where

import String (indexes,fromChar,toList)
import List (map,head,reverse,indexedMap,foldr)

-- convert a hexadecimal String into an Int
decimalFromHex : String -> Int
decimalFromHex hexString =
    let xs = reverse <| toList hexString
        vals = map (head << flip indexes "0123456789ABCDEF0123456789abcdef" << fromChar) xs
        powered = indexedMap (\idx val -> (16 ^ idx) * (val % 16)) vals
    in foldr (+) 0 powered

