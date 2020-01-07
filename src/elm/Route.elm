module Route exposing (Route(..), fromUrl, href, parser)

import Html
import Html.Attributes
import Url
import Url.Parser as Parser exposing (Parser)



-- TYPES


type Route
    = Home
    | Api
    | About



-- PARSER


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Api (Parser.s "api")
        , Parser.map About (Parser.s "about")
        ]



-- HTML HELPERS


href : Route -> Html.Attribute msg
href =
    toString >> Html.Attributes.href



-- CONVERSION


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        Api ->
            "/api"

        About ->
            "/about"


fromUrl : Url.Url -> Maybe Route
fromUrl =
    Parser.parse parser
