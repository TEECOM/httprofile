module Page.NotFound exposing (view)

import Browser
import Html exposing (text)



-- VIEW


view : Browser.Document Never
view =
    { title = "Not Found"
    , body = [ text "Not Found" ]
    }
