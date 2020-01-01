module Profile.Report exposing (AggregateTimeline, DiscreteTimeline, Report, decoder)

import Header exposing (Header)
import Json.Decode as Decode exposing (Decoder)



-- TYPES


type alias Report =
    { protocol : String
    , status : Int
    , headers : List Header
    , body : String
    , discreteTimeline : DiscreteTimeline
    , aggregateTimeline : AggregateTimeline
    }


type alias DiscreteTimeline =
    { dnsLookupDuration : Int
    , tcpConnectionDuration : Int
    , tlsHandshakeDuration : Int
    , serverProcessingDuration : Int
    , contentTransferDuration : Int
    }


type alias AggregateTimeline =
    { timeToNameLookup : Int
    , timeToConnect : Int
    , timeToPreTransfer : Int
    , timeToStartTransfer : Int
    , totalRequestTime : Int
    }



-- SERIALIZATION


decoder : Decoder Report
decoder =
    Decode.map6 Report
        (Decode.field "protocol" Decode.string)
        (Decode.field "status" Decode.int)
        (Decode.field "headers" Header.decoder)
        (Decode.field "body" Decode.string)
        discreteTimelineDecoder
        aggregateTimelineDecoder


discreteTimelineDecoder : Decoder DiscreteTimeline
discreteTimelineDecoder =
    Decode.map5 DiscreteTimeline
        (Decode.field "dnsLookupDuration" Decode.int)
        (Decode.field "tcpConnectionDuration" Decode.int)
        (Decode.field "tlsHandshakeDuration" Decode.int)
        (Decode.field "serverProcessingDuration" Decode.int)
        (Decode.field "contentTransferDuration" Decode.int)


aggregateTimelineDecoder : Decoder AggregateTimeline
aggregateTimelineDecoder =
    Decode.map5 AggregateTimeline
        (Decode.field "timeToNameLookup" Decode.int)
        (Decode.field "timeToConnect" Decode.int)
        (Decode.field "timeToPreTransfer" Decode.int)
        (Decode.field "timeToStartTransfer" Decode.int)
        (Decode.field "totalRequestTime" Decode.int)
