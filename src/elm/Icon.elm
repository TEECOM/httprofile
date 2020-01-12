module Icon exposing (bulb, downCarrot, heart, logo, minus, plus)

import Html exposing (Html)
import Svg exposing (circle, path, rect, svg)
import Svg.Attributes exposing (class, cx, cy, d, height, r, rx, viewBox, width, x, y)


logo : Html Never
logo =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-6" ]
        [ path [ d "M10 20a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm-5.6-4.29a9.95 9.95 0 0 1 11.2 0 8 8 0 1 0-11.2 0zm6.12-7.64l3.02-3.02 1.41 1.41-3.02 3.02a2 2 0 1 1-1.41-1.41z" ] [] ]


downCarrot : Html Never
downCarrot =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-4 w-4" ]
        [ path [ d "M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" ] [] ]


plus : Html Never
plus =
    svg
        [ viewBox "0 0 24 24", class "fill-current h-6" ]
        [ circle [ cx "12", cy "12", r "10" ] []
        , path [ d "M13 11h4a1 1 0 0 1 0 2h-4v4a1 1 0 0 1-2 0v-4H7a1 1 0 0 1 0-2h4V7a1 1 0 0 1 2 0v4z", class "fill-current text-gray-900" ] []
        ]


minus : Html Never
minus =
    svg
        [ viewBox "0 0 24 24", class "fill-current h-6" ]
        [ circle [ cx "12", cy "12", r "10" ] []
        , rect [ width "12", height "2", x "6", y "11", rx "1", class "fill-current text-gray-900" ] []
        ]


heart : Html Never
heart =
    svg
        [ viewBox "0 0 20 20", class "fill-current h-4 hover:text-red-700" ]
        [ path [ d "M10 3.22l-.61-.6a5.5 5.5 0 0 0-7.78 7.77L10 18.78l8.39-8.4a5.5 5.5 0 0 0-7.78-7.77l-.61.61z" ] [] ]


bulb : Html Never
bulb =
    svg
        [ viewBox "0 0 352 512", class "fill-current h-4 hover:text-yellow-500" ]
        [ path [ d "M96.06 454.35c.01 6.29 1.87 12.45 5.36 17.69l17.09 25.69a31.99 31.99 0 0 0 26.64 14.28h61.71a31.99 31.99 0 0 0 26.64-14.28l17.09-25.69a31.989 31.989 0 0 0 5.36-17.69l.04-38.35H96.01l.05 38.35zM0 176c0 44.37 16.45 84.85 43.56 115.78 16.52 18.85 42.36 58.23 52.21 91.45.04.26.07.52.11.78h160.24c.04-.26.07-.51.11-.78 9.85-33.22 35.69-72.6 52.21-91.45C335.55 260.85 352 220.37 352 176 352 78.61 272.91-.3 175.45 0 73.44.31 0 82.97 0 176zm176-80c-44.11 0-80 35.89-80 80 0 8.84-7.16 16-16 16s-16-7.16-16-16c0-61.76 50.24-112 112-112 8.84 0 16 7.16 16 16s-7.16 16-16 16z" ] [] ]
