module HeaderTests exposing (suite)

import Expect
import Fuzz exposing (string)
import Header exposing (Header(..))
import Http
import Json.Decode exposing (decodeString)
import Json.Encode as Encode
import Test exposing (..)


suite : Test
suite =
    describe "The Header module"
        [ key, value, mapKey, mapValue, decoder, encode ]


key : Test
key =
    describe "Header.key"
        [ fuzz string "returns the Header's key" <|
            \headerKey ->
                Header.header headerKey ""
                    |> Header.key
                    |> Expect.equal headerKey
        ]


value : Test
value =
    describe "Header.value"
        [ fuzz string "returns the Header's value" <|
            \headerValue ->
                Header.header "" headerValue
                    |> Header.value
                    |> Expect.equal headerValue
        ]


mapKey : Test
mapKey =
    describe "Header.mapKey"
        [ fuzz string "updates the Header's key" <|
            \headerKey ->
                Header.empty
                    |> Header.mapKey (always headerKey)
                    |> Header.key
                    |> Expect.equal headerKey
        , fuzz string "doesn't change the Header's value" <|
            \headerKey ->
                Header.empty
                    |> Header.mapKey (always headerKey)
                    |> Header.value
                    |> Expect.equal ""
        ]


mapValue : Test
mapValue =
    describe "Header.mapValue"
        [ fuzz string "updates the Header's value" <|
            \headerValue ->
                Header.empty
                    |> Header.mapValue (always headerValue)
                    |> Header.value
                    |> Expect.equal headerValue
        , fuzz string "doesn't change the Header's key" <|
            \headerValue ->
                Header.empty
                    |> Header.mapValue (always headerValue)
                    |> Header.key
                    |> Expect.equal ""
        ]


decoder : Test
decoder =
    describe "Header.decoder"
        [ test "can decode empty headers" <|
            \() ->
                "{}"
                    |> decodeString Header.decoder
                    |> Expect.equal (Ok [])
        , test "can decode a single header" <|
            \() ->
                "{\"Key\":\"Value\"}"
                    |> decodeString Header.decoder
                    |> Expect.equal (Ok [ Header.header "Key" "Value" ])
        , test "can decode a real-world set of headers" <|
            \() ->
                "{\"Accept\":\"application/json; charset=utf-8\",\"Access-Control-Allow-Origin\":\"*\",\"Content-Length\":\"42\",\"Content-Type\":\"application/json; charset=utf-8\"}"
                    |> decodeString Header.decoder
                    |> Expect.equal
                        (Ok
                            [ Header.header "Accept" "application/json; charset=utf-8"
                            , Header.header "Access-Control-Allow-Origin" "*"
                            , Header.header "Content-Length" "42"
                            , Header.header "Content-Type" "application/json; charset=utf-8"
                            ]
                        )
        ]


encode : Test
encode =
    describe "Header.encode"
        [ test "can encode empty headers" <|
            \() ->
                []
                    |> Header.encode
                    |> Encode.encode 0
                    |> Expect.equal "{}"
        , test "can encode single headers" <|
            \() ->
                [ Header.header "Key" "Value" ]
                    |> Header.encode
                    |> Encode.encode 0
                    |> Expect.equal "{\"Key\":\"Value\"}"
        , test "can encode a real-world set of headers" <|
            \() ->
                [ Header.header "Accept" "application/json; charset=utf-8"
                , Header.header "Access-Control-Allow-Origin" "*"
                , Header.header "Content-Length" "42"
                , Header.header "Content-Type" "application/json; charset=utf-8"
                ]
                    |> Header.encode
                    |> Encode.encode 0
                    |> Expect.equal "{\"Accept\":\"application/json; charset=utf-8\",\"Access-Control-Allow-Origin\":\"*\",\"Content-Length\":\"42\",\"Content-Type\":\"application/json; charset=utf-8\"}"
        ]
