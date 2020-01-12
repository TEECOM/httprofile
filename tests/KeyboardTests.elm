module KeyboardTests exposing (suite)

import Expect
import Json.Decode as Decode exposing (decodeString)
import Keyboard exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "The Keyboard module"
        [ decoder ]


decoder : Test
decoder =
    describe "Keyboard.decoder"
        [ test "can recognize specified commands" <|
            \() ->
                """
                {
                  "target": { "tagName": "TEXTAREA" },
                  "key": "Enter",
                  "altKey": false,
                  "ctrlKey": false,
                  "metaKey": true,
                  "shiftKey": false
                }
                """
                    |> decodeString (Keyboard.decoder shortcuts)
                    |> Expect.equal (Ok SubmitForm)
        , test "can ignore commands based on tag name" <|
            \() ->
                """
                {
                  "target": { "tagName": "INPUT" },
                  "key": "d",
                  "altKey": false,
                  "ctrlKey": false,
                  "metaKey": false,
                  "shiftKey": false
                }
                """
                    |> decodeString (Keyboard.decoder shortcuts)
                    |> Expect.err
        , test "can handle commands with non-inclusive tag names" <|
            \() ->
                """
                {
                  "target": { "tagName": "BODY" },
                  "key": "d",
                  "altKey": false,
                  "ctrlKey": false,
                  "metaKey": false,
                  "shiftKey": false
                }
                """
                    |> decodeString (Keyboard.decoder shortcuts)
                    |> Expect.equal (Ok HideDetails)
        , test "can handle commands with many meta keys" <|
            \() ->
                """
                {
                  "target": { "tagName": "BODY" },
                  "key": "e",
                  "altKey": true,
                  "ctrlKey": true,
                  "metaKey": true,
                  "shiftKey": false
                }
                """
                    |> decodeString (Keyboard.decoder shortcuts)
                    |> Expect.equal (Ok RevealEasterEgg)
        , test "can handle unknown commands" <|
            \() ->
                """
                {
                  "target": { "tagName": "BODY" },
                  "key": "f
                  "altKey": false,
                  "ctrlKey": true,
                  "metaKey": true,
                  "shiftKey": false
                }
                """
                    |> decodeString (Keyboard.decoder shortcuts)
                    |> Expect.err
        ]


type Shortcut
    = SubmitForm
    | HideDetails
    | RevealEasterEgg


shortcuts : Keyboard.Event -> Keyboard.Command Shortcut
shortcuts event =
    case event of
        Keyboard.Event "INPUT" _ _ ->
            Keyboard.Unrecognized

        Keyboard.Event "TEXTAREA" "Enter" [ Keyboard.Meta ] ->
            Keyboard.Recognized SubmitForm

        Keyboard.Event _ "d" _ ->
            Keyboard.Recognized HideDetails

        Keyboard.Event _ "e" [ Keyboard.Ctrl, Keyboard.Alt, Keyboard.Meta ] ->
            Keyboard.Recognized RevealEasterEgg

        _ ->
            Keyboard.Unrecognized
