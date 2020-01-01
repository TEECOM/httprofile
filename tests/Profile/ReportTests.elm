module Profile.ReportTests exposing (suite)

import Expect
import Header
import Json.Decode exposing (decodeString)
import Profile.Report
import Test exposing (..)


suite : Test
suite =
    describe "The Profile.Report module"
        [ decoder ]


decoder : Test
decoder =
    describe "Profile.Report.decoder"
        [ test "can decode a real-world response" <|
            \() ->
                realWorldResponse
                    |> decodeString Profile.Report.decoder
                    |> Expect.equal (Ok expectedReport)
        ]


realWorldResponse : String
realWorldResponse =
    "{\"protocol\":\"HTTP/1.1\",\"status\":200,\"headers\":{\"Accept\":\"application/json; charset=utf-8\",\"Access-Control-Allow-Origin\":\"*\",\"Content-Length\":\"27\",\"Content-Type\":\"application/json; charset=utf-8\",\"Date\":\"Wed, 01 Jan 2020 14:14:23 GMT\"},\"body\":\"{\\\"message\\\":\\\"Hello World!\\\"}\\n\",\"dnsLookupDuration\":481387,\"tcpConnectionDuration\":209086,\"tlsHandshakeDuration\":0,\"serverProcessingDuration\":444833,\"contentTransferDuration\":19944,\"timeToNameLookup\":481387,\"timeToConnect\":690473,\"timeToPreTransfer\":722258,\"timeToStartTransfer\":1167091,\"totalRequestTime\":1187035}"


expectedReport : Profile.Report.Report
expectedReport =
    { protocol = "HTTP/1.1"
    , status = 200
    , headers =
        [ Header.header "Accept" "application/json; charset=utf-8"
        , Header.header "Access-Control-Allow-Origin" "*"
        , Header.header "Content-Length" "27"
        , Header.header "Content-Type" "application/json; charset=utf-8"
        , Header.header "Date" "Wed, 01 Jan 2020 14:14:23 GMT"
        ]
    , body = "{\"message\":\"Hello World!\"}\n"
    , discreteTimeline =
        { dnsLookupDuration = 481387
        , tcpConnectionDuration = 209086
        , tlsHandshakeDuration = 0
        , serverProcessingDuration = 444833
        , contentTransferDuration = 19944
        }
    , aggregateTimeline =
        { timeToNameLookup = 481387
        , timeToConnect = 690473
        , timeToPreTransfer = 722258
        , timeToStartTransfer = 1167091
        , totalRequestTime = 1187035
        }
    }
