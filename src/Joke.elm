module Joke exposing (..)

import Http
import Json.Decode exposing ((:=), Decoder)
import Task
import Debug exposing (log)

type Msg
    = FetchSuccess JokeResponse
    | FetchFailure Http.Error

type alias JokeResponse =
    {
        value: JokeJson
    }

type alias JokeJson = 
    {
        joke: String
    }

update : String -> Msg -> String
update currentJoke msg =
    case msg of
        FetchSuccess jokeResponse -> jokeResponse.value.joke
        FetchFailure error -> 
            case error of
                Http.UnexpectedPayload errorMsg -> 
                    Debug.log errorMsg
                    errorMsg
                _ -> "Some other error occured"


fetchRandomJoke : (Cmd Msg)
fetchRandomJoke =
    let task = Http.get jokeResponseDecoder "http://api.icndb.com/jokes/random"
    in Task.perform FetchFailure FetchSuccess task


jokeResponseDecoder : Decoder JokeResponse
jokeResponseDecoder =
    Json.Decode.object1 JokeResponse
        ("value" := jokeDecoder)

jokeDecoder : Decoder JokeJson
jokeDecoder =
    Json.Decode.object1 JokeJson
        ("joke" := Json.Decode.string)
