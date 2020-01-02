module List.Extra exposing (Position(..), mapOnly, positionedMap, removeAt)

-- TYPES


type Position
    = Position Int Int



-- FUNCTIONS


mapOnly : Int -> (a -> a) -> List a -> List a
mapOnly index transform =
    List.indexedMap
        (\idx val ->
            if index == idx then
                transform val

            else
                val
        )


positionedMap : (Position -> a -> b) -> List a -> List b
positionedMap f xs =
    List.indexedMap (\i x -> f (Position i (List.length xs - 1)) x) xs


removeAt : Int -> List a -> List a
removeAt idx xs =
    let
        head =
            List.take idx xs

        tail =
            List.drop (idx + 1) xs
    in
    head ++ tail
