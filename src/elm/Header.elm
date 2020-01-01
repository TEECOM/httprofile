module Header exposing (Header, decoder, empty, header, key, toHttp, updateKey, updateValue, value)

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


updateKey : Key -> Header -> Header
updateKey k (Header _ v) =
    Header k v


updateValue : Value -> Header -> Header
updateValue v (Header k _) =
    Header k v



-- SERIALIZATION


decoder : Decoder (List Header)
decoder =
    Decode.map (List.map fromPair)
        (Decode.keyValuePairs Decode.string)
