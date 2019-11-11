module Main exposing (Model)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Random



-- MAIN


main =
    Browser.element
        { init = initial_model
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias CpuProcess =
    { p_name : String
    , burst_size : Int
    , priority : Int
    }


type alias SimParameters =
    { algorithm : String
    , processes : List CpuProcess
    , quantum : Int
    }


type alias ProcessTimeDatum =
    { p_name : String
    , wait_time : Int
    , turnaround_time : Int
    }


type alias GanttDatum =
    { p_name : String
    , start_time : Int
    , stop_time : Int
    }


type alias SimOutput =
    { process_times : List ProcessTimeDatum
    , gantt_data : List GanttDatum
    , average_wait_time : Float
    , average_turnaround_time : Float
    }


type alias Model =
    { sim_parameter_record : SimParameters
    , sim_output_record : SimOutput
    , seed : Random.Seed
    , process_burst_size_input : String
    , process_priority_input : String
    }


initial_model : () -> ( Model, Cmd Msg )
initial_model _ =
    ( { sim_parameter_record =
            { algorithm = "FCFS"
            , processes = []
            , quantum = 0
            }
      , sim_output_record =
            { process_times = []
            , gantt_data = []
            , average_wait_time = 0
            , average_turnaround_time = 0
            }
      , seed = Random.initialSeed 31415
      , process_burst_size_input = "32"
      , process_priority_input = "32"
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ Background.color color_palatte.background_1 ] <|
        column [ height fill, width fill ]
            [ headerRow
            , addProcessRow model
            ]


header : Element Msg
header =
    el
        [ centerX
        , Font.color color_palatte.text_1
        , Font.size size_palatte.large
        ]
        (text "CPU Scheduler")


headerRow : Element Msg
headerRow =
    row
        [ width fill
        , Background.color color_palatte.background_1
        , alignTop
        , padding 30
        ]
        [ header ]


addProcessRow : Model -> Element Msg
addProcessRow model =
    row
        [ width fill
        , Background.color color_palatte.background_1
        ]
        [ addProcessButton model
        , processBurstSizePrompt
        , processBurstSizeEntry model
        , processPriorityPrompt
        , processPriorityEntry model
        ]


processBurstSizePrompt : Element Msg
processBurstSizePrompt =
    el
        [ Font.color color_palatte.text_1
        , Font.size size_palatte.normal
        ]
        (text "Process burst size:")


processBurstSizeEntry : Model -> Element Msg
processBurstSizeEntry model =
    Input.text
        []
        { placeholder = Just (Input.placeholder [] (text "32"))
        , label = Input.labelHidden "burst_size"
        , text = model.process_burst_size_input
        , onChange = \new -> Update { model | process_burst_size_input = new }
        }


processPriorityPrompt : Element Msg
processPriorityPrompt =
    el
        [ Font.color color_palatte.text_1
        , Font.size size_palatte.normal
        ]
        (text "Process priority:")


processPriorityEntry : Model -> Element Msg
processPriorityEntry model =
    Input.text
        []
        { placeholder = Just (Input.placeholder [] (text "32"))
        , label = Input.labelHidden "priority"
        , text = model.process_priority_input
        , onChange = \new -> Update { model | process_priority_input = new }
        }


addProcessButton : Model -> Element Msg
addProcessButton model =
    Input.button
        []
        { label = text "ADD"
        , onPress = Nothing
        }


size_palatte =
    { xxsmall = 4
    , xsmall = 8
    , small = 16
    , normal = 32
    , large = 64
    , xlarge = 128
    , xxlarge = 256
    }


color_palatte =
    { background_1 = rgb255 113 238 184
    , text_1 = rgb 255 255 255
    }



-- UPDATE


type Msg
    = Update Model
    | AddProcess


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update new ->
            ( new, Cmd.none )

        AddProcess ->
            let
                cpu_process =
                    { p_name = "", burst_size = model.process_burst_size_input, priority = model.process_priority_input }
            in
            ( model, Cmd.none )


setSeed : Random.Seed -> Model -> Model
setSeed new_seed model =
    { model | seed = new_seed }


setNewSeed : Model -> Model
setNewSeed model =
    let
        new_seed =
            Tuple.second (Random.step (Random.int 0 0) model.seed)
    in
    setSeed new_seed model


addProcessToSimParameterRecord : CpuProcess -> Model -> Model
addProcessToSimParameterRecord cpu_process ({ sim_parameter_record } as model) =
    { model
        | sim_parameter_record = { sim_parameter_record | processes = sim_parameter_record.processes ++ [ cpu_process ] }
    }


removeProcessFromSimParameterRecord : Int -> Model -> Model
removeProcessFromSimParameterRecord num ({ sim_parameter_record } as model) =
    { model
        | sim_parameter_record =
            { sim_parameter_record
                | processes = List.take num sim_parameter_record.processes ++ List.drop (num + 1) sim_parameter_record.processes
            }
    }


buildCpuProcess : String -> Int -> Int -> CpuProcess
buildCpuProcess name burst pri =
    { p_name = name, burst_size = burst, priority = pri }


generateRandomIntBetween0And127 : Random.Generator Int
generateRandomIntBetween0And127 =
    Random.int 0 127


generateRandomIntBetweenXAndY : Int -> Int -> Random.Generator Int
generateRandomIntBetweenXAndY x y =
    Random.int x y



-- COMMAND


randomNumberBetween0And127 : Model -> Int
randomNumberBetween0And127 model =
    Random.step generateRandomIntBetween0And127 model.seed |> Tuple.first


randomNumberBetweenXAndY : Int -> Int -> Model -> Int
randomNumberBetweenXAndY x y model =
    Random.step (generateRandomIntBetweenXAndY x y) model.seed |> Tuple.first



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
