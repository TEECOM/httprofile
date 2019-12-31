module HeaderTests exposing (suite)

import Expect
import Fuzz exposing (string)
import Header exposing (Header(..))
import Http
import Test exposing (..)


suite : Test
suite =
    describe "The Header module"
        [ key, value, updateKey, updateValue ]


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
