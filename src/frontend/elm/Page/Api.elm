module Page.Api exposing (Model, Msg, init, subscriptions, update, view)

import Browser
import Html exposing (Html, a, code, div, h3, p, pre, span, text)
import Html.Attributes exposing (class, href, target)
import SyntaxHighlight



-- MODEL


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( (), Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view _ =
    { title = "API Documentation"
    , body =
        [ div [ class "text-lg leading-relaxed mb-12" ]
            [ div []
                [ p [] [ text "The HTTProfile API has a single endpoint for profiling HTTP servers." ]
                , div [ class "mt-8" ]
                    [ div []
                        [ span [ class "bg-pink-600 text-gray-900 px-2 py-1 rounded font-bold text-base" ] [ text "POST" ]
                        , span [ class "mx-2 bg-gray-800 px-3 py-1 rounded font-mono text-base" ] [ text "https://api.httprofile.io/report" ]
                        ]
                    , viewCodeExample [ class "mt-4" ] requestExample
                    ]
                , p [ class "mt-16" ] [ text "If the profile is completed without error, you can expect a JSON response that looks something like this:" ]
                , viewCodeExample [ class "mt-8" ] responseExample
                , p [ class "mt-10" ]
                    [ text "The "
                    , viewField "protocol"
                    , text " , "
                    , viewField "status"
                    , text " , "
                    , viewField "headers"
                    , text " , and "
                    , viewField "body"
                    , text " fields all refer to the response content of the profiled endpoint."
                    ]
                , p [ class "mt-8" ]
                    [ text "The "
                    , viewField "...Duration"
                    , text " fields all refer to the "
                    , span [ class "font-bold italic" ] [ text "discrete" ]
                    , text " request / response timeline in nanoseconds. In this context, \"discrete\" means that each step is timed separately."
                    ]
                , p [ class "mt-8" ]
                    [ text "The "
                    , viewField "timeTo..."
                    , text " fields all refer to the "
                    , span [ class "font-bold italic" ] [ text "aggregate" ]
                    , text " request / response timeline in nanoseconds. In this context, \"aggregate\" means that each duration represents the time to complete a given step "
                    , span [ class "font-bold" ] [ text "and all previous steps" ]
                    , text "."
                    ]
                , p [ class "mt-8" ]
                    [ text "The "
                    , viewField "totalRequestTime"
                    , text " is the total time it took to receive a response in nanoseconds."
                    ]
                ]
            , div [ class "mt-16" ]
                [ h3 [ class "text-xl font-bold mb-3" ] [ text "Errors" ]
                , span [] [ text "In some cases, a profile request will fail. When this happens, an error response will be returned with this format: " ]
                , viewCodeExample [ class "mt-8" ] errorResponseExample
                , p []
                    [ text "If you consistently run into an error, please feel free to "
                    , viewLink [ href "https://github.com/TEECOM/httprofile/issues/new?labels=bug%20:bug:" ] [ text "open an issue" ]
                    , text " with your error response."
                    ]
                ]
            , div [ class "mt-16" ]
                [ h3 [ class "text-xl font-bold mb-3" ] [ text "Cross Origin Resource Sharing (CORS)" ]
                , p []
                    [ text " The API supports Cross Origin Resource Sharing (CORS) for AJAX requests from any origin. "
                    , text " You can read the "
                    , viewLink [ href "http://www.w3.org/TR/cors/" ] [ text "CORS W3C Recommendation" ]
                    , text ", or "
                    , viewLink [ href "http://code.google.com/p/html5security/wiki/CrossOriginRequestSecurity" ] [ text "this intro" ]
                    , text " from the HTML 5 Security Guide."
                    ]
                ]
            ]
        ]
    }


viewCodeExample : List (Html.Attribute msg) -> String -> Html msg
viewCodeExample attributes exampleText =
    div ([ class "mb-10 px-6 py-4 bg-gray-800 rounded overflow-auto scroll-dark" ] ++ attributes)
        [ SyntaxHighlight.json exampleText
            |> Result.map (SyntaxHighlight.toBlockHtml Nothing)
            |> Result.withDefault (text "")
        ]


viewField : String -> Html msg
viewField name =
    span [ class "bg-gray-800 px-2 py-1 rounded" ] [ text name ]


viewLink : List (Html.Attribute msg) -> List (Html msg) -> Html msg
viewLink attributes =
    a ([ target "_blank", class "font-bold border-b border-1 text-gray-300 hover:text-gray-100" ] ++ attributes)


requestExample : String
requestExample =
    """{
    "method": "PATCH",
    "url": "https://jsonplaceholder.typicode.com/posts/1",
    "headers": {
        "Content-type": "application/json; charset=UTF-8",
        "Accept": "application/json; charset=UTF-8"
    },
    "body": "{ \\"title\\": \\"A new title\\" }"
}
"""


responseExample : String
responseExample =
    """{
    "protocol": "HTTP/2.0",
    "status": 200,
    "headers": {
        "Content-Type": "application/json; charset=utf-8"
    },
    "body": "{ \\"id\\": 1, \\"title\\": \\"A new title\\", ... }",
    "dnsLookupDuration": 0,
    "tcpConnectionDuration": 0,
    "tlsHandshakeDuration": 0,
    "serverProcessingDuration": 99499547,
    "contentTransferDuration": 80612,
    "timeToNameLookup": 0,
    "timeToConnect": 0,
    "timeToPreTransfer": 0,
    "timeToStartTransfer": 99499547,
    "totalRequestTime": 99580159
}
"""


errorResponseExample : String
errorResponseExample =
    """{
    "error": {
        "status": 400,
        "type": "UnparseableBody",
        "message": "Something is off with the request body: EOF.",
        "traceID": "bof4l9nan4102ogtu2bg"
    }
}
"""



-- MESSAGE


type alias Msg =
    ()



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none
