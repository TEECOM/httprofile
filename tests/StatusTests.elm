module StatusTests exposing (suite)

import Expect
import Status
import Test exposing (..)


suite : Test
suite =
    describe "The Status module"
        [ text ]


text : Test
text =
    describe "Status.text"
        [ test "returns the status text of valid status codes" <|
            \() ->
                418
                    |> Status.text
                    |> Expect.equal "I'm a teapot"
        , test "returns an empty string for unknown status codes" <|
            \() ->
                900
                    |> Status.text
                    |> Expect.equal ""
        ]
