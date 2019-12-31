module Header exposing (Header, header, key, value)

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



-- INFO


key : Header -> Key
key (Header k _) =
    k


value : Header -> Value
value (Header _ v) =
    v
