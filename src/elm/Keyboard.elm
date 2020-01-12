module Keyboard exposing (Command(..), Event(..), Modifier(..), decoder)

import Json.Decode as Decode exposing (Decoder)



-- TYPES


type alias Tag =
    String


type alias Key =
    String


type Event
    = Event Tag Key (List Modifier)


type Modifier
    = Ctrl
    | Alt
    | Meta
    | Shift


type Command a
    = Recognized a
    | Unrecognized



-- SERIALIZATION


decoder : (Event -> Command a) -> Decoder a
decoder toCommand =
    eventDecoder
        |> Decode.andThen
            (\event ->
                case toCommand event of
                    Recognized a ->
                        Decode.succeed a

                    Unrecognized ->
                        Decode.fail "Unrecognized keyboard command."
            )


eventDecoder : Decoder Event
eventDecoder =
    Decode.map3 Event
        (Decode.at [ "target", "tagName" ] Decode.string)
        (Decode.field "key" Decode.string)
        modifiersDecoder


modifiersDecoder : Decoder (List Modifier)
modifiersDecoder =
    Decode.map4 (\c a m s -> List.filterMap identity [ c, a, m, s ])
        (modifierDecoder Ctrl "ctrlKey")
        (modifierDecoder Alt "altKey")
        (modifierDecoder Meta "metaKey")
        (modifierDecoder Shift "shiftKey")


modifierDecoder : Modifier -> String -> Decoder (Maybe Modifier)
modifierDecoder mod str =
    Decode.field str Decode.bool
        |> Decode.map
            (\b ->
                if b then
                    Just mod

                else
                    Nothing
            )
