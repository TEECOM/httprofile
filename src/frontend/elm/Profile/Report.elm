module Profile.Report exposing (AggregateTimeline, DiscreteTimeline, Report, decoder)

import Duration exposing (Duration)
import Header exposing (Header)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline



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
    Decode.succeed Report
        |> Pipeline.required "protocol" Decode.string
        |> Pipeline.required "status" Decode.int
        |> Pipeline.required "headers" Header.decoder
        |> Pipeline.required "body" Decode.string
        |> Pipeline.custom discreteTimelineDecoder
        |> Pipeline.custom aggregateTimelineDecoder


discreteTimelineDecoder : Decoder DiscreteTimeline
discreteTimelineDecoder =
    Decode.succeed DiscreteTimeline
        |> Pipeline.required "dnsLookupDuration" durationDecoder
        |> Pipeline.required "tcpConnectionDuration" durationDecoder
        |> Pipeline.required "tlsHandshakeDuration" durationDecoder
        |> Pipeline.required "serverProcessingDuration" durationDecoder
        |> Pipeline.required "contentTransferDuration" durationDecoder


aggregateTimelineDecoder : Decoder AggregateTimeline
aggregateTimelineDecoder =
    Decode.succeed AggregateTimeline
        |> Pipeline.required "timeToNameLookup" durationDecoder
        |> Pipeline.required "timeToConnect" durationDecoder
        |> Pipeline.required "timeToPreTransfer" durationDecoder
        |> Pipeline.required "timeToStartTransfer" durationDecoder
        |> Pipeline.required "totalRequestTime" durationDecoder


durationDecoder : Decoder Duration
durationDecoder =
    Decode.int |> Decode.map (toFloat >> Duration.nanoseconds)
