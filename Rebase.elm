module Rebase (decFromHex) where
import String as S

charset_hex = "0123456789ABCDEF0123456789abcdef"

decFromHex hexString =
    let
        ss = List.reverse <| S.toList hexString
        vals = List.filterMap (List.head << flip S.indexes charset_hex << S.fromChar) ss
        pwrd = List.indexedMap (\x v -> (16^x)*(v%16)) vals
    in List.foldr (+) 0 pwrd

