module RouteTests exposing (suite)

import Expect
import Html.Attributes
import Route
import Test exposing (..)
import Url
import Url.Parser


suite : Test
suite =
    describe "The Route module"
        [ parser, href, toString, fromUrl ]


parser : Test
parser =
    describe "Route.parser"
        [ test "can parse the Home route" <|
            \() ->
                Url.fromString "https://test.com/"
                    |> Maybe.andThen (Url.Parser.parse Route.parser)
                    |> Expect.equal (Just Route.Home)
        , test "can parse the Api route" <|
            \() ->
                Url.fromString "https://test.com/api"
                    |> Maybe.andThen (Url.Parser.parse Route.parser)
                    |> Expect.equal (Just Route.Api)
        , test "can parse the About route" <|
            \() ->
                Url.fromString "https://test.com/about"
                    |> Maybe.andThen (Url.Parser.parse Route.parser)
                    |> Expect.equal (Just Route.About)
        , test "can handle unknown routes" <|
            \() ->
                Url.fromString "https://test.com/unknown"
                    |> Maybe.andThen (Url.Parser.parse Route.parser)
                    |> Expect.equal Nothing
        ]


href : Test
href =
    describe "Route.href"
        [ test "can turn the Home route into an 'href' attribute" <|
            \() ->
                Route.href Route.Home
                    |> Expect.equal (Html.Attributes.href "/")
        , test "can turn the Api route into an 'href' attribute" <|
            \() ->
                Route.href Route.Api
                    |> Expect.equal (Html.Attributes.href "/api")
        , test "can turn the About route into an 'href' attribute" <|
            \() ->
                Route.href Route.About
                    |> Expect.equal (Html.Attributes.href "/about")
        ]


toString : Test
toString =
    describe "Route.toString"
        [ test "can turn the Home route into a string" <|
            \() ->
                Route.toString Route.Home
                    |> Expect.equal "/"
        , test "can turn the Api route into a string" <|
            \() ->
                Route.toString Route.Api
                    |> Expect.equal "/api"
        , test "can turn the About route into a string" <|
            \() ->
                Route.toString Route.About
                    |> Expect.equal "/about"
        ]


fromUrl : Test
fromUrl =
    describe "Route.fromUrl"
        [ test "can parse the Home route" <|
            \() ->
                Url.fromString "https://test.com/"
                    |> Maybe.andThen Route.fromUrl
                    |> Expect.equal (Just Route.Home)
        , test "can parse the Api route" <|
            \() ->
                Url.fromString "https://test.com/api"
                    |> Maybe.andThen Route.fromUrl
                    |> Expect.equal (Just Route.Api)
        , test "can parse the About route" <|
            \() ->
                Url.fromString "https://test.com/about"
                    |> Maybe.andThen Route.fromUrl
                    |> Expect.equal (Just Route.About)
        , test "can handle unknown routes" <|
            \() ->
                Url.fromString "https://test.com/unknown"
                    |> Maybe.andThen Route.fromUrl
                    |> Expect.equal Nothing
        ]
