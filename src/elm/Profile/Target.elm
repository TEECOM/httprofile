module Profile.Target exposing (Target, encode)

import Header exposing (Header)
import Json.Encode as Encode
import Verbs exposing (Verb)



-- TYPES


type alias Target =
    { verb : Verb
    , url : String
    , headers : List Header
    , body : String
    }



-- SERIALIZATION


encode : Target -> Encode.Value
encode target =
    Encode.object
        [ ( "method", Verbs.encode target.verb )
        , ( "url", Encode.string target.url )
        , ( "headers", Header.encode target.headers )
        , ( "body", Encode.string target.body )
        ]
