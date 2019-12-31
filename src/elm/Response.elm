module Response exposing (Response)

import Header


type alias Response =
    { protocol : String
    , status : String
    , headers : Header.Header
    , body : String
    , dnsDuration : String
    , tcpConnectionDuration : String
    , tlsHandshakeDuration : String
    , serverProcessingDuration : String
    , contentTransferDuration : String
    , timeToNameLookup : String
    , timeToConnect : String
    , timeToPreTransfer : String
    , timeToStartTransfer : String
    , totalRequestTime : String
    }
