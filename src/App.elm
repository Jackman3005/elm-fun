module App exposing (..)

import Html exposing (..)
import Html.App
import Joke
import VirtualDom
import Json.Encode as Encode

type alias Model =
    {
        joke: String
    }

type Msg    
    = JokeMsg Joke.Msg

initialModel : Model
initialModel =
    { joke = "Nope" }


init : (Model, Cmd Msg)
init =
    (initialModel, Cmd.map JokeMsg Joke.fetchRandomJoke)

innerHtml : String -> Attribute Msg
innerHtml =
    VirtualDom.property "innerHTML" << Encode.string

view : Model -> (Html Msg)
view model =
    section [] [
        h1 [] [ text "Welcome" ],
        p [ innerHtml model.joke ] []
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JokeMsg jokeMsg ->
            let newJoke = (Joke.update model.joke jokeMsg)
            in ({ model | joke = newJoke }, Cmd.none)


main : Program Never
main = Html.App.program
    {
            init = init,
            view = view,
            update = update,
            subscriptions = (always Sub.none)
    }