module Verbs exposing (Verb(..), all, decoder, fromString, targetValueDecoder, toString)

import Html.Events exposing (targetValue)
import Json.Decode as Decode exposing (Decoder)



-- TYPES


type Verb
    = Get
    | Post
    | Put
    | Patch
    | Delete
    | Head
    | Connect
    | Options
    | Trace



-- INFO


all : List Verb
all =
    [ Get, Post, Put, Patch, Delete, Head, Connect, Options, Trace ]



-- CONVERSION


toString : Verb -> String
toString verb =
    case verb of
        Get ->
            "GET"

        Post ->
            "POST"

        Put ->
            "PUT"

        Patch ->
            "PATCH"

        Delete ->
            "DELETE"

        Head ->
            "HEAD"

        Connect ->
            "CONNECT"

        Options ->
            "OPTIONS"

        Trace ->
            "TRACE"


fromString : String -> Maybe Verb
fromString str =
    case str of
        "GET" ->
            Just Get

        "POST" ->
            Just Post

        "PUT" ->
            Just Put

        "PATCH" ->
            Just Patch

        "DELETE" ->
            Just Delete

        "HEAD" ->
            Just Head

        "CONNECT" ->
            Just Connect

        "OPTIONS" ->
            Just Options

        "TRACE" ->
            Just Trace

        _ ->
            Nothing



-- SERIALIZATION


decoder : Decoder Verb
decoder =
    Decode.string |> Decode.andThen decoderFromString


targetValueDecoder : Decoder Verb
targetValueDecoder =
    targetValue |> Decode.andThen decoderFromString


decoderFromString : String -> Decoder Verb
decoderFromString str =
    case fromString str of
        Just verb ->
            Decode.succeed verb

        Nothing ->
            Decode.fail <| "Unknown HTTP verb \"" ++ str ++ "\"."
