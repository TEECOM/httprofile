module Profile.TargetTests exposing (suite)

import Expect
import Header
import Json.Encode as Encode
import Profile.Target
import Test exposing (..)
import Verb


suite : Test
suite =
    describe "The Profile.Target module"
        [ encode ]


encode : Test
encode =
    describe "Profile.Target.encode"
        [ test "can encode a minimal Target" <|
            \() ->
                { verb = Verb.Get
                , url = "http://test.com"
                , headers = []
                , body = ""
                }
                    |> Profile.Target.encode
                    |> Encode.encode 0
                    |> Expect.equal "{\"method\":\"GET\",\"url\":\"http://test.com\",\"headers\":{},\"body\":\"\"}"
        , test "can encode a more realistic Target" <|
            \() ->
                { verb = Verb.Post
                , url = "http://test.com"
                , headers = [ Header.header "Content-Type" "application/json" ]
                , body = "{\"message\":\"Hello World!\"}"
                }
                    |> Profile.Target.encode
                    |> Encode.encode 0
                    |> Expect.equal "{\"method\":\"POST\",\"url\":\"http://test.com\",\"headers\":{\"Content-Type\":\"application/json\"},\"body\":\"{\\\"message\\\":\\\"Hello World!\\\"}\"}"
        ]
