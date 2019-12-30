module VerbsTests exposing (suite)

import Expect
import Fuzz exposing (string)
import Json.Decode exposing (decodeString, errorToString)
import Test exposing (..)
import Verbs exposing (Verb(..))


suite : Test
suite =
    describe "The Verbs module"
        [ all, toString, fromString, decoder, targetValueDecoder ]


all : Test
all =
    describe "Verbs.all"
        [ test "returns all Verb variants" <|
            \() ->
                Expect.equal
                    [ Get, Post, Put, Patch, Delete, Head, Connect, Options, Trace ]
                    Verbs.all
        ]


toString : Test
toString =
    describe "Verbs.toString"
        [ test "returns 'GET' for Get" <|
            \() ->
                Get
                    |> Verbs.toString
                    |> Expect.equal "GET"
        , test "returns 'POST' for Post" <|
            \() ->
                Post
                    |> Verbs.toString
                    |> Expect.equal "POST"
        , test "returns 'PUT' for Put" <|
            \() ->
                Put
                    |> Verbs.toString
                    |> Expect.equal "PUT"
        , test "returns 'PATCH' for Patch" <|
            \() ->
                Patch
                    |> Verbs.toString
                    |> Expect.equal "PATCH"
        , test "returns 'DELETE' for Delete" <|
            \() ->
                Delete
                    |> Verbs.toString
                    |> Expect.equal "DELETE"
        , test "returns 'HEAD' for Head" <|
            \() ->
                Head
                    |> Verbs.toString
                    |> Expect.equal "HEAD"
        , test "returns 'CONNECT' for Connect" <|
            \() ->
                Connect
                    |> Verbs.toString
                    |> Expect.equal "CONNECT"
        , test "returns 'OPTIONS' for Options" <|
            \() ->
                Options
                    |> Verbs.toString
                    |> Expect.equal "OPTIONS"
        , test "returns 'TRACE' for Trace" <|
            \() ->
                Trace
                    |> Verbs.toString
                    |> Expect.equal "TRACE"
        ]


fromString : Test
fromString =
    describe "Verbs.fromString"
        [ test "returns Get for 'GET'" <|
            \() ->
                "GET"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Get)
        , test "returns Post for 'POST'" <|
            \() ->
                "POST"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Post)
        , test "returns Put for 'PUT'" <|
            \() ->
                "PUT"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Put)
        , test "returns Patch for 'PATCH'" <|
            \() ->
                "PATCH"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Patch)
        , test "returns Delete for 'DELETE'" <|
            \() ->
                "DELETE"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Delete)
        , test "returns Head for 'HEAD'" <|
            \() ->
                "HEAD"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Head)
        , test "returns Connect for 'CONNECT'" <|
            \() ->
                "CONNECT"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Connect)
        , test "returns Options for 'OPTIONS'" <|
            \() ->
                "OPTIONS"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Options)
        , test "returns Trace for 'TRACE'" <|
            \() ->
                "TRACE"
                    |> Verbs.fromString
                    |> Expect.equal (Ok Trace)
        , fuzz string "returns Nothing for unknown verbs" <|
            \unknownVerb ->
                unknownVerb
                    |> Verbs.fromString
                    |> Expect.equal (Err <| "Unknown HTTP verb \"" ++ unknownVerb ++ "\".")
        ]


decoder : Test
decoder =
    describe "Verbs.decoder"
        [ test "can decode GETs" <|
            \() ->
                "\"GET\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Get)
        , test "can decode POSTs" <|
            \() ->
                "\"POST\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Post)
        , test "can decode PUTs" <|
            \() ->
                "\"PUT\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Put)
        , test "can decode PATCHs" <|
            \() ->
                "\"PATCH\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Patch)
        , test "can decode DELETEs" <|
            \() ->
                "\"DELETE\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Delete)
        , test "can decode HEADs" <|
            \() ->
                "\"HEAD\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Head)
        , test "can decode CONNECTs" <|
            \() ->
                "\"CONNECT\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Connect)
        , test "can decode OPTIONSs" <|
            \() ->
                "\"OPTIONS\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Options)
        , test "can decode TRACEs" <|
            \() ->
                "\"TRACE\""
                    |> decodeString Verbs.decoder
                    |> Expect.equal (Ok Trace)
        , fuzz string "cannot decode other strings" <|
            \str ->
                ("\"" ++ str ++ "\"")
                    |> decodeString Verbs.decoder
                    |> Expect.err
        ]


targetValueDecoder : Test
targetValueDecoder =
    describe "Verbs.targetValueDecoder"
        [ test "can decode GETs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"GET\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Get)
        , test "can decode POSTs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"POST\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Post)
        , test "can decode PUTs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"PUT\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Put)
        , test "can decode PATCHs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"PATCH\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Patch)
        , test "can decode DELETEs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"DELETE\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Delete)
        , test "can decode HEADs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"HEAD\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Head)
        , test "can decode CONNECTs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"CONNECT\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Connect)
        , test "can decode OPTIONSs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"OPTIONS\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Options)
        , test "can decode TRACEs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"TRACE\"}}"
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.equal (Ok Trace)
        , fuzz string "cannot decode other strings as target values" <|
            \str ->
                ("{\"target\":{\"value\":\"" ++ str ++ "\"}}")
                    |> decodeString Verbs.targetValueDecoder
                    |> Expect.err
        ]
