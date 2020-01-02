module VerbTests exposing (suite)

import Expect
import Fuzz exposing (string)
import Json.Decode exposing (decodeString, errorToString)
import Json.Encode as Encode
import Test exposing (..)
import Verb exposing (Verb(..))


suite : Test
suite =
    describe "The Verb module"
        [ all, toString, fromString, decoder, targetValueDecoder, encode ]


all : Test
all =
    describe "Verb.all"
        [ test "returns all Verb variants" <|
            \() ->
                Expect.equal
                    [ Get, Post, Put, Patch, Delete, Head, Connect, Options, Trace ]
                    Verb.all
        ]


toString : Test
toString =
    describe "Verb.toString"
        [ test "returns 'GET' for Get" <|
            \() ->
                Get
                    |> Verb.toString
                    |> Expect.equal "GET"
        , test "returns 'POST' for Post" <|
            \() ->
                Post
                    |> Verb.toString
                    |> Expect.equal "POST"
        , test "returns 'PUT' for Put" <|
            \() ->
                Put
                    |> Verb.toString
                    |> Expect.equal "PUT"
        , test "returns 'PATCH' for Patch" <|
            \() ->
                Patch
                    |> Verb.toString
                    |> Expect.equal "PATCH"
        , test "returns 'DELETE' for Delete" <|
            \() ->
                Delete
                    |> Verb.toString
                    |> Expect.equal "DELETE"
        , test "returns 'HEAD' for Head" <|
            \() ->
                Head
                    |> Verb.toString
                    |> Expect.equal "HEAD"
        , test "returns 'CONNECT' for Connect" <|
            \() ->
                Connect
                    |> Verb.toString
                    |> Expect.equal "CONNECT"
        , test "returns 'OPTIONS' for Options" <|
            \() ->
                Options
                    |> Verb.toString
                    |> Expect.equal "OPTIONS"
        , test "returns 'TRACE' for Trace" <|
            \() ->
                Trace
                    |> Verb.toString
                    |> Expect.equal "TRACE"
        ]


fromString : Test
fromString =
    describe "Verb.fromString"
        [ test "returns Get for 'GET'" <|
            \() ->
                "GET"
                    |> Verb.fromString
                    |> Expect.equal (Ok Get)
        , test "returns Post for 'POST'" <|
            \() ->
                "POST"
                    |> Verb.fromString
                    |> Expect.equal (Ok Post)
        , test "returns Put for 'PUT'" <|
            \() ->
                "PUT"
                    |> Verb.fromString
                    |> Expect.equal (Ok Put)
        , test "returns Patch for 'PATCH'" <|
            \() ->
                "PATCH"
                    |> Verb.fromString
                    |> Expect.equal (Ok Patch)
        , test "returns Delete for 'DELETE'" <|
            \() ->
                "DELETE"
                    |> Verb.fromString
                    |> Expect.equal (Ok Delete)
        , test "returns Head for 'HEAD'" <|
            \() ->
                "HEAD"
                    |> Verb.fromString
                    |> Expect.equal (Ok Head)
        , test "returns Connect for 'CONNECT'" <|
            \() ->
                "CONNECT"
                    |> Verb.fromString
                    |> Expect.equal (Ok Connect)
        , test "returns Options for 'OPTIONS'" <|
            \() ->
                "OPTIONS"
                    |> Verb.fromString
                    |> Expect.equal (Ok Options)
        , test "returns Trace for 'TRACE'" <|
            \() ->
                "TRACE"
                    |> Verb.fromString
                    |> Expect.equal (Ok Trace)
        , fuzz string "returns Nothing for unknown verbs" <|
            \unknownVerb ->
                unknownVerb
                    |> Verb.fromString
                    |> Expect.equal (Err <| "Unknown HTTP verb \"" ++ unknownVerb ++ "\".")
        ]


decoder : Test
decoder =
    describe "Verb.decoder"
        [ test "can decode GETs" <|
            \() ->
                "\"GET\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Get)
        , test "can decode POSTs" <|
            \() ->
                "\"POST\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Post)
        , test "can decode PUTs" <|
            \() ->
                "\"PUT\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Put)
        , test "can decode PATCHs" <|
            \() ->
                "\"PATCH\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Patch)
        , test "can decode DELETEs" <|
            \() ->
                "\"DELETE\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Delete)
        , test "can decode HEADs" <|
            \() ->
                "\"HEAD\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Head)
        , test "can decode CONNECTs" <|
            \() ->
                "\"CONNECT\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Connect)
        , test "can decode OPTIONSs" <|
            \() ->
                "\"OPTIONS\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Options)
        , test "can decode TRACEs" <|
            \() ->
                "\"TRACE\""
                    |> decodeString Verb.decoder
                    |> Expect.equal (Ok Trace)
        , fuzz string "cannot decode other strings" <|
            \str ->
                ("\"" ++ str ++ "\"")
                    |> decodeString Verb.decoder
                    |> Expect.err
        ]


targetValueDecoder : Test
targetValueDecoder =
    describe "Verb.targetValueDecoder"
        [ test "can decode GETs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"GET\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Get)
        , test "can decode POSTs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"POST\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Post)
        , test "can decode PUTs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"PUT\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Put)
        , test "can decode PATCHs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"PATCH\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Patch)
        , test "can decode DELETEs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"DELETE\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Delete)
        , test "can decode HEADs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"HEAD\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Head)
        , test "can decode CONNECTs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"CONNECT\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Connect)
        , test "can decode OPTIONSs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"OPTIONS\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Options)
        , test "can decode TRACEs as target values" <|
            \() ->
                "{\"target\":{\"value\":\"TRACE\"}}"
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.equal (Ok Trace)
        , fuzz string "cannot decode other strings as target values" <|
            \str ->
                ("{\"target\":{\"value\":\"" ++ str ++ "\"}}")
                    |> decodeString Verb.targetValueDecoder
                    |> Expect.err
        ]


encode : Test
encode =
    describe "Verb.encode"
        [ test "can encode Get" <|
            \() ->
                Get
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"GET\""
        , test "can encode Post" <|
            \() ->
                Post
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"POST\""
        , test "can encode Put" <|
            \() ->
                Put
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"PUT\""
        , test "can encode Patch" <|
            \() ->
                Patch
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"PATCH\""
        , test "can encode Delete" <|
            \() ->
                Delete
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"DELETE\""
        , test "can encode Head" <|
            \() ->
                Head
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"HEAD\""
        , test "can encode Connect" <|
            \() ->
                Connect
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"CONNECT\""
        , test "can encode Options" <|
            \() ->
                Options
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"OPTIONS\""
        , test "can encode Trace" <|
            \() ->
                Trace
                    |> Verb.encode
                    |> Encode.encode 0
                    |> Expect.equal "\"TRACE\""
        ]
