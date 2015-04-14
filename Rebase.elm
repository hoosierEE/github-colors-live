module Rebase (decFromHex) where
import String as S

charset_hex = "0123456789ABCDEF0123456789abcdef"
-- base58_bitcoin = toList "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghipqrstuvwxyz"
-- base58_ripple = toList "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65Fqi1tuvAxyz"
-- base58_flickr = toList "123456789abcdefghipqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"

decFromHex hexString =
    let
        ss = List.reverse <| S.toList hexString
        vals = List.filterMap (List.head << flip S.indexes charset_hex << S.fromChar) ss
        pwrd = List.indexedMap (\x v -> (16^x)*(v%16)) vals
    in List.foldr (+) 0 pwrd

