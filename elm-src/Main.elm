module Main exposing (..)

import Browser as Browser
import Generated.Autogen as HT exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (attribute, checked, class, placeholder, style, type_)
import Html.Events exposing (onCheck, onClick, onInput)
import Http

main : Program () Model Msg
main = Browser.element
    { init = always (initialModel, post HT.RequestInitialValue)
    , view = view
    , update = update
    , subscriptions = always (Sub.none)
    }

type alias Model =
    { message : String
    , counter : Int
    }

type Msg
    = GotMessageFromHaskell HT.HaskellToElmMessage
    | DecodeErrorDetect Http.Error
    | Increment
    | Submit

initialModel : Model
initialModel =
    { message = "No error message received"
    , counter = 0
    }

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text model.message ]
    , button [ onClick Increment ] [ text "+" ]
    , div [] [ text (String.fromInt model.counter) ]
    , button [ onClick Submit ] [ text "submit" ]
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMessageFromHaskell hsMsg -> case hsMsg of
            HT.CurrentCounterValue n -> ( { model | counter = n }, Cmd.none )
        DecodeErrorDetect err ->
            ( { model | message = fromErr err }, Cmd.none )
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )
        Submit ->
            ( model, post (HT.UpdateCounterValue model.counter) )

fromErr : Http.Error -> String
fromErr err = case err of
    Http.BadUrl str -> "BadUrl " ++ str
    Http.Timeout -> "Timeout"
    Http.NetworkError -> "NetworkError"
    Http.BadStatus n -> "BadStatus " ++ String.fromInt n
    Http.BadBody str -> "BadBody " ++ str

post : HT.ElmToHaskellMessage -> Cmd Msg
post msg =
    let toMsg : Result Http.Error HT.HaskellToElmMessage -> Msg
        toMsg eMsg = case eMsg of
            Err err -> DecodeErrorDetect err
            Ok hsMsg -> GotMessageFromHaskell hsMsg
    in Http.request
           { method  = "POST"
           , headers = []
           , url     = "http://localhost:8080"
           , body    = Http.jsonBody (HT.encodeElmToHaskellMessage msg)
           , expect  = Http.expectJson toMsg HT.decodeHaskellToElmMessage
           , timeout = Nothing
           , tracker = Nothing
           }
