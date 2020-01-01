module Verbs exposing (Verb(..), all, decoder, encode, fromString, targetValueDecoder, toString)

import Html.Events exposing (targetValue)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode



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


fromString : String -> Result String Verb
fromString str =
    case str of
        "GET" ->
            Ok Get

        "POST" ->
            Ok Post

        "PUT" ->
            Ok Put

        "PATCH" ->
            Ok Patch

        "DELETE" ->
            Ok Delete

        "HEAD" ->
            Ok Head

        "CONNECT" ->
            Ok Connect

        "OPTIONS" ->
            Ok Options

        "TRACE" ->
            Ok Trace

        _ ->
            Err ("Unknown HTTP verb \"" ++ str ++ "\".")



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
        Ok verb ->
            Decode.succeed verb

        Err error ->
            Decode.fail error


encode : Verb -> Encode.Value
encode =
    toString >> Encode.string
