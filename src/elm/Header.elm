module Header exposing (Header, decoder, empty, header, key, mapKey, mapValue, toHttp, value)

import Http
import Json.Decode as Decode exposing (Decoder)



-- TYPES


type Header
    = Header String String


type alias Key =
    String


type alias Value =
    String



-- CONSTRUCTORS


header : Key -> Value -> Header
header k v =
    Header k v


empty : Header
empty =
    Header "" ""


fromPair : ( Key, Value ) -> Header
fromPair ( k, v ) =
    Header k v



-- INFO


key : Header -> Key
key (Header k _) =
    k


value : Header -> Value
value (Header _ v) =
    v



-- TRANSFORMS


toHttp : Header -> Http.Header
toHttp (Header k v) =
    Http.header k v


mapKey : (Key -> Key) -> Header -> Header
mapKey transform (Header k v) =
    Header (transform k) v


mapValue : (Value -> Value) -> Header -> Header
mapValue transform (Header k v) =
    Header k (transform v)



-- SERIALIZATION


decoder : Decoder (List Header)
decoder =
    Decode.map (List.map fromPair)
        (Decode.keyValuePairs Decode.string)
