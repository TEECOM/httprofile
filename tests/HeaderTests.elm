module HeaderTests exposing (suite)

import Expect
import Fuzz exposing (string)
import Header exposing (Header(..))
import Http
import Json.Decode exposing (decodeString)
import Test exposing (..)


suite : Test
suite =
    describe "The Header module"
        [ key, value, updateKey, updateValue, decoder ]


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


updateKey : Test
updateKey =
    describe "Header.updateKey"
        [ fuzz string "updates the Header's key" <|
            \headerKey ->
                Header.empty
                    |> Header.updateKey headerKey
                    |> Header.key
                    |> Expect.equal headerKey
        , fuzz string "doesn't change the Header's value" <|
            \headerKey ->
                Header.empty
                    |> Header.updateKey headerKey
                    |> Header.value
                    |> Expect.equal ""
        ]


updateValue : Test
updateValue =
    describe "Header.updateValue"
        [ fuzz string "updates the Header's value" <|
            \headerValue ->
                Header.empty
                    |> Header.updateValue headerValue
                    |> Header.value
                    |> Expect.equal headerValue
        , fuzz string "doesn't change the Header's key" <|
            \headerValue ->
                Header.empty
                    |> Header.updateValue headerValue
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
