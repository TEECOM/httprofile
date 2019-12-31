module Header exposing (Header, empty, header, key, toHttp, value)

import Http



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



-- INFO


key : Header -> Key
key (Header k _) =
    k


value : Header -> Value
value (Header _ v) =
    v



-- CONVERSION


toHttp : Header -> Http.Header
toHttp (Header k v) =
    Http.header k v
