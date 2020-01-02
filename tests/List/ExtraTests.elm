module List.ExtraTests exposing (suite)

import Expect
import List.Extra
import Test exposing (..)


suite : Test
suite =
    describe "The List.Extra module"
        [ mapOnly, positionedMap, removeAt ]


mapOnly : Test
mapOnly =
    describe "List.Extra.mapOnly"
        [ test "applies a transformation at the given index" <|
            \() ->
                [ "a", "b", "c" ]
                    |> List.Extra.mapOnly 1 String.toUpper
                    |> Expect.equal [ "a", "B", "c" ]
        ]


positionedMap : Test
positionedMap =
    describe "List.Extra.positionedMap"
        [ test "applies a transformation, yielding positional information" <|
            \() ->
                List.repeat 5 ()
                    |> List.Extra.positionedMap (\p _ -> p)
                    |> Expect.equal
                        [ List.Extra.Position 0 4
                        , List.Extra.Position 1 4
                        , List.Extra.Position 2 4
                        , List.Extra.Position 3 4
                        , List.Extra.Position 4 4
                        ]
        ]


removeAt : Test
removeAt =
    describe "List.Extra.removeAt"
        [ test "removes the element at the specified index" <|
            \() ->
                [ "a", "b", "c" ]
                    |> List.Extra.removeAt 1
                    |> Expect.equal [ "a", "c" ]
        ]
