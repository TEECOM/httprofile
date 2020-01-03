module DurationTests exposing (suite)

import Duration
import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (float)
import Test exposing (..)


suite : Test
suite =
    describe "The Duration module"
        [ inNanoseconds, inMilliseconds ]


inNanoseconds : Test
inNanoseconds =
    describe "Duration.inNanoseconds"
        [ fuzz float "is the opposite of 'nanoseconds'" <|
            \f ->
                f
                    |> Duration.nanoseconds
                    |> Duration.inNanoseconds
                    |> Expect.within (Absolute 0.000001) f
        , test "can convert other durations" <|
            \() ->
                Duration.milliseconds 100
                    |> Duration.inNanoseconds
                    |> Expect.within (Absolute 0.000001) 100000000
        ]


inMilliseconds : Test
inMilliseconds =
    describe "Duration.inMilliseconds"
        [ fuzz float "is the opposite of 'milliseconds'" <|
            \f ->
                f
                    |> Duration.milliseconds
                    |> Duration.inMilliseconds
                    |> Expect.within (Absolute 0.000001) f
        , test "can convert other durations" <|
            \() ->
                Duration.nanoseconds 347397664
                    |> Duration.inMilliseconds
                    |> Expect.within (Absolute 0.000001) 347.397664
        ]
