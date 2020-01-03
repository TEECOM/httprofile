module StatusTests exposing (suite)

import Expect
import Fuzz exposing (intRange)
import Random
import Status
import Test exposing (..)


suite : Test
suite =
    describe "The Status module"
        [ category, text ]


category : Test
category =
    describe "Status.category"
        [ fuzz (intRange 100 199) "returns Informational for any 1xx code" <|
            \code ->
                code
                    |> Status.category
                    |> Expect.equal Status.Informational
        , fuzz (intRange 200 299) "returns Success for any 2xx code" <|
            \code ->
                code
                    |> Status.category
                    |> Expect.equal Status.Success
        , fuzz (intRange 300 399) "returns Redirection for any 3xx code" <|
            \code ->
                code
                    |> Status.category
                    |> Expect.equal Status.Redirection
        , fuzz (intRange 400 499) "returns ClientError for any 4xx code" <|
            \code ->
                code
                    |> Status.category
                    |> Expect.equal Status.ClientError
        , fuzz (intRange 500 599) "returns ServerError for any 5xx code" <|
            \code ->
                code
                    |> Status.category
                    |> Expect.equal Status.ServerError
        , fuzz (intRange 600 Random.maxInt) "returns Unknown for anything else" <|
            \code ->
                code
                    |> Status.category
                    |> Expect.equal Status.Unknown
        ]


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
