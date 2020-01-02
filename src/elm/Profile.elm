module Profile exposing (run)

import Http
import Profile.Report as Report exposing (Report)
import Profile.Target as Target exposing (Target)
import Verb


run : (Result Http.Error Report -> msg) -> Target -> Cmd msg
run toMsg target =
    Http.request
        { method = "POST"
        , headers = []
        , url = "https://api.httprofile.io/report"
        , body = Http.jsonBody (Target.encode target)
        , expect = Http.expectJson toMsg Report.decoder
        , timeout = Nothing
        , tracker = Nothing
        }
