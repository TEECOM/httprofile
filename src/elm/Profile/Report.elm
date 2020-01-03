module Profile.Report exposing (AggregateTimeline, DiscreteTimeline, Report, decoder)

import Duration exposing (Duration)
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
    { dnsLookupDuration : Duration
    , tcpConnectionDuration : Duration
    , tlsHandshakeDuration : Duration
    , serverProcessingDuration : Duration
    , contentTransferDuration : Duration
    }


type alias AggregateTimeline =
    { timeToNameLookup : Duration
    , timeToConnect : Duration
    , timeToPreTransfer : Duration
    , timeToStartTransfer : Duration
    , totalRequestTime : Duration
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
        (Decode.field "dnsLookupDuration" durationDecoder)
        (Decode.field "tcpConnectionDuration" durationDecoder)
        (Decode.field "tlsHandshakeDuration" durationDecoder)
        (Decode.field "serverProcessingDuration" durationDecoder)
        (Decode.field "contentTransferDuration" durationDecoder)


aggregateTimelineDecoder : Decoder AggregateTimeline
aggregateTimelineDecoder =
    Decode.map5 AggregateTimeline
        (Decode.field "timeToNameLookup" durationDecoder)
        (Decode.field "timeToConnect" durationDecoder)
        (Decode.field "timeToPreTransfer" durationDecoder)
        (Decode.field "timeToStartTransfer" durationDecoder)
        (Decode.field "totalRequestTime" durationDecoder)


durationDecoder : Decoder Duration
durationDecoder =
    Decode.int |> Decode.map (toFloat >> Duration.nanoseconds)
