module HeaderTests exposing (suite)

import Expect
import Fuzz exposing (string)
import Header exposing (Header(..))
import Test exposing (..)


suite : Test
suite =
    describe "The Header module"
        [ key, value ]


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
