module Rebase (dfh) where
-- import Graphics.Element exposing (flow,down,show)
import String as S

charset_hex = "0123456789ABCDEF0123456789abcdef"
-- base58_bitcoin = toList "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghipqrstuvwxyz"
-- base58_ripple = toList "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65Fqi1tuvAxyz"
-- base58_flickr = toList "123456789abcdefghipqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"

dfh hexString =
    let
        ss = List.reverse <| S.toList hexString
        vals = List.filterMap (List.head << flip S.indexes charset_hex << S.fromChar) ss
        pwrd = List.indexedMap (\x v -> (16^x)*(v%16)) vals
    in List.foldr (+) 0 pwrd


-- error if any of the given chars aren't part of the list

-- charList = toList "azAZ"
-- intList = toList "0123456789"
--
-- -- charTest lst = List.map (flip (List.member) charset_hex) lst
-- a = dfh "1a"
-- b = dfh "hi"
-- c = dfh "0"
-- main = flow down <| List.map (show << dfh) ["10","11","ff","hello"]
