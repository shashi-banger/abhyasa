
module Main exposing (..)

import Browser
import Html exposing (div, text, input, button)
import String exposing(fromInt, toInt)
import Html.Events exposing(onClick, onInput)
import Debug exposing (log)

add a b = a + b

type Messages =
    Add
    | ChangedText String

init = { value = 97, 
        valueToAdd=0}

update msg model = 
    let
        lm1 = log "message" msg
        lm2 = log "model" model
    in
        case msg of
            Add ->
                {model | value = model.value + model.valueToAdd}

            ChangedText theText ->
                { model | valueToAdd = (parseTextToInt theText) }

parseTextToInt text = 
    let
        val = toInt text
    in  
        case val of
            Just v ->
                v 
            Nothing ->
                0

view model =
    div [] [
        text (fromInt model.value),
        div [] [],
        input [ onInput ChangedText ] [],
        button [onClick Add] [text "Add"]
        ]

main = Browser.sandbox 
    {
        init = init
        , view = view
        , update = update
    }





