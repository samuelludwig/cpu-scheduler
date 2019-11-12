module Main exposing (Model)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (optional, optionalAt, required, requiredAt)
import Json.Encode as Encode exposing (..)
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
            { algorithm = "first_come_first_serve"
            , processes = []
            , quantum = 6
            }
      , sim_output_record =
            { process_times = []
            , gantt_data = []
            , average_wait_time = 0
            , average_turnaround_time = 0
            }
      , seed = Random.initialSeed 31415
      , process_burst_size_input = "8"
      , process_priority_input = "4"
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ Background.color color_palette.background_1 ] <|
        column [ height fill, width fill ]
            [ headerRow
            , algorithmSelector model
            , quantumRow model
            , outputTablesRow model
            , averageTimesRow model
            , ganttChart model
            , addProcessRow model
            ]

quantumPrompt : Model -> Element Msg
quantumPrompt model =
    el
        []
        (text "Quantum")

quantumEntry : Model -> Element Msg
quantumEntry ({sim_parameter_record} as model) =
    Input.text
        []
        { placeholder = Just (Input.placeholder [] (text "6"))
        , label = Input.labelHidden "quantum"
        , text = String.fromInt model.sim_parameter_record.quantum
        , onChange =
              \new ->
                  Update { model
                         | sim_parameter_record = {sim_parameter_record | quantum = (Maybe.withDefault 0 (String.toInt new))}
                         }
        }

quantumRow : Model -> Element Msg
quantumRow model =
    row
        []
        [ quantumPrompt model
        , quantumEntry model
        ]

ganttChart : Model -> Element Msg
ganttChart model =
    el
        []
        (text (ganttDataToString model))


averageTimesRow : Model -> Element Msg
averageTimesRow model =
    row
        []
        [ averageTurnaroundTimeLabel model
        , averageTurnaroundTimeDisplay model
        , averageWaitTimeLabel model
        , averageWaitTimeDisplay model
        ]


header : Element Msg
header =
    el
        [ centerX
        , Font.color color_palette.text_1
        , Font.size size_palette.large
        ]
        (text "CPU Scheduler")


headerRow : Element Msg
headerRow =
    row
        [ width fill
        , Background.color color_palette.background_1
        , alignTop
        , padding size_palette.normal
        , spacing size_palette.normal
        ]
        [ header ]


addProcessRow : Model -> Element Msg
addProcessRow model =
    row
        [ width fill
        , Background.color color_palette.background_1
        , padding size_palette.normal
        , spacing size_palette.normal
        ]
        [ addProcessButton model
        , processBurstSizePrompt
        , processBurstSizeEntry model
        , processPriorityPrompt
        , processPriorityEntry model
        , calculateButton model
        ]


processBurstSizePrompt : Element Msg
processBurstSizePrompt =
    el
        [ Font.color color_palette.text_1
        , Font.size size_palette.normal
        ]
        (text "Process burst size:")


processBurstSizeEntry : Model -> Element Msg
processBurstSizeEntry model =
    Input.text
        []
        { placeholder = Just (Input.placeholder [] (text "8"))
        , label = Input.labelHidden "burst_size"
        , text = model.process_burst_size_input
        , onChange = \new -> Update { model | process_burst_size_input = new }
        }


processPriorityPrompt : Element Msg
processPriorityPrompt =
    el
        [ Font.color color_palette.text_1
        , Font.size size_palette.normal
        ]
        (text "Process priority:")


processPriorityEntry : Model -> Element Msg
processPriorityEntry model =
    Input.text
        []
        { placeholder = Just (Input.placeholder [] (text "4"))
        , label = Input.labelHidden "priority"
        , text = model.process_priority_input
        , onChange = \new -> Update { model | process_priority_input = new }
        }


addProcessButton : Model -> Element Msg
addProcessButton model =
    Input.button
        [ Font.color color_palette.text_1
        , Font.size size_palette.normal
        , Border.color color_palette.border_1
        ]
        { label = text "ADD"
        , onPress = Just (AddProcess model)
        }


calculateButton : Model -> Element Msg
calculateButton model =
    Input.button
        []
        { label = text "CALCULATE"
        , onPress = Just CalculateOutput
        }


processTable : Model -> Element Msg
processTable model =
    Element.table
        []
        { data = model.sim_parameter_record.processes
        , columns =
            [ { header = Element.text "Process Name"
              , width = fill
              , view =
                    \process ->
                        Element.text process.p_name
              }
            , { header = Element.text "Burst Size"
              , width = fill
              , view =
                    \process ->
                        Element.text (String.fromInt process.burst_size)
              }
            , { header = Element.text "Priority"
              , width = fill
              , view =
                    \process ->
                        Element.text (String.fromInt process.priority)
              }
            ]
        }


processTimesTable : Model -> Element Msg
processTimesTable model =
    Element.table
        []
        { data = model.sim_output_record.process_times
        , columns =
            [ { header = Element.text "Process Name"
              , width = fill
              , view =
                    \process ->
                        Element.text process.p_name
              }
            , { header = Element.text "Wait Time"
              , width = fill
              , view =
                    \process ->
                        Element.text (String.fromInt process.wait_time)
              }
            , { header = Element.text "Turnaround Time"
              , width = fill
              , view =
                    \process ->
                        Element.text (String.fromInt process.turnaround_time)
              }
            ]
        }


outputTablesRow : Model -> Element Msg
outputTablesRow model =
    row
        []
        [ processTable model
        , processTimesTable model
        ]


averageTurnaroundTimeLabel : Model -> Element Msg
averageTurnaroundTimeLabel model =
    Element.el
        [ Font.color color_palette.text_1
        , Font.size size_palette.normal
        ]
        (text "Average Turnaround Time:")


averageTurnaroundTimeDisplay : Model -> Element Msg
averageTurnaroundTimeDisplay model =
    Element.el
        []
        (text (String.fromFloat model.sim_output_record.average_turnaround_time))


averageWaitTimeLabel : Model -> Element Msg
averageWaitTimeLabel model =
    Element.el
        [ Font.color color_palette.text_1
        , Font.size size_palette.normal
        ]
        (text "Average Wait Time:")


averageWaitTimeDisplay : Model -> Element Msg
averageWaitTimeDisplay model =
    Element.el
        []
        (text (String.fromFloat model.sim_output_record.average_wait_time))


algorithmSelector : Model -> Element Msg
algorithmSelector ({ sim_parameter_record } as model) =
    Input.radio
        [ padding 10
        , spacing 20
        ]
        { onChange = \new -> Update { model | sim_parameter_record = { sim_parameter_record | algorithm = new } }
        , selected = Just model.sim_parameter_record.algorithm
        , label = Input.labelAbove [] (text "Algorithm")
        , options =
            [ Input.option "first_come_first_serve" (text "FCFS")
            , Input.option "shortest_job_first" (text "SJF")
            , Input.option "priority" (text "PRI")
            , Input.option "round_robin" (text "RR")
            ]
        }



-- PALETTES


size_palette =
    { xxsmall = 4
    , xsmall = 8
    , small = 16
    , normal = 32
    , large = 64
    , xlarge = 128
    , xxlarge = 256
    }


color_palette =
    { background_1 = rgb255 113 238 184
    , text_1 = rgb255 255 255 255
    , border_1 = rgb255 113 238 255
    }



-- UPDATE


ganttDatumToString : GanttDatum -> String
ganttDatumToString datum =
    let
        name =
            datum.p_name

        start =
            String.fromInt datum.start_time

        stop =
            String.fromInt datum.stop_time
    in
    "| " ++ start ++ " <- " ++ name ++ " -> " ++ stop ++ " |"


ganttDataToString : Model -> String
ganttDataToString model =
    let
        data =
            model.sim_output_record.gantt_data

        stringified_data =
            List.map ganttDatumToString data
    in
    String.join "" stringified_data


type Msg
    = Update Model
    | AddProcess Model
    | CalculateOutput
    | DataReceived (Result Http.Error SimOutput)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message: " msg of
        Update new ->
            ( new, Cmd.none )

        AddProcess mod ->
            let
                cpu_process =
                    buildCpuProcessFromInputFields mod
            in
            ( addProcessToSimParameterRecord cpu_process mod, Cmd.none )

        CalculateOutput ->
            ( model
            , buildHttpRequest model
            )

        DataReceived (Ok str) ->
            ( { model | sim_output_record = str }, Cmd.none )

        DataReceived (Err _) ->
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


buildCpuProcessFromInputFields : Model -> CpuProcess
buildCpuProcessFromInputFields model =
    let
        process_number =
            List.length model.sim_parameter_record.processes + 1

        name =
            "P" ++ String.fromInt process_number

        burst =
            stringToInt model.process_burst_size_input

        pri =
            stringToInt model.process_priority_input
    in
    { p_name = name, burst_size = burst, priority = pri }


stringToInt : String -> Int
stringToInt str =
    Maybe.withDefault 1 (String.toInt str)


randomizeInputFieldValues : Model -> Model
randomizeInputFieldValues model =
    model


decodeJsonIntoSimOutputRecord : String -> SimOutput
decodeJsonIntoSimOutputRecord str =
    case Decode.decodeString simOutputDecoder str of
        Ok record ->
            record

        Err error ->
            { process_times = [ { p_name = "PX", wait_time = 0, turnaround_time = 1 } ]
            , gantt_data = [ { p_name = "PX", start_time = 0, stop_time = 1 } ]
            , average_wait_time = 3.2
            , average_turnaround_time = 3.2
            }



-- COMMAND


buildHttpRequest : Model -> Cmd Msg
buildHttpRequest model =
    Http.post
        { url = "http://127.0.0.1:8085/calculate"
        , body = Http.jsonBody (encodeSimParameterRecordIntoJson model)
        , expect = Http.expectJson DataReceived simOutputDecoder
        }


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



-- DECODERS


simOutputDecoder : Decoder SimOutput
simOutputDecoder =
    Decode.succeed SimOutput
        |> required "process_times" processTimesDecoder
        |> required "gantt_data" ganttDataDecoder
        |> required "average_wait_time" Decode.float
        |> required "average_turnaround_time" Decode.float


ganttDataDecoder : Decoder (List GanttDatum)
ganttDataDecoder =
    Decode.list ganttDatumDecoder


ganttDatumDecoder : Decoder GanttDatum
ganttDatumDecoder =
    Decode.succeed GanttDatum
        |> required "p_name" Decode.string
        |> required "start_time" Decode.int
        |> required "stop_time" Decode.int


processTimesDecoder : Decoder (List ProcessTimeDatum)
processTimesDecoder =
    Decode.list processTimeDatumDecoder


processTimeDatumDecoder : Decoder ProcessTimeDatum
processTimeDatumDecoder =
    Decode.succeed ProcessTimeDatum
        |> required "p_name" Decode.string
        |> required "wait_time" Decode.int
        |> required "turnaround_time" Decode.int



-- ENCODERS


encodeSimParameterRecordIntoJson : Model -> Encode.Value
encodeSimParameterRecordIntoJson model =
    let
        algorithm =
            model.sim_parameter_record.algorithm

        quantum =
            model.sim_parameter_record.quantum

        processes =
            model.sim_parameter_record.processes
    in
    object
        [ ( "algorithm", Encode.string algorithm )
        , ( "quantum", Encode.int quantum )
        , encodeListOfProcessesIntoJson processes
        ]


encodeProcessRecordIntoJson : CpuProcess -> Encode.Value
encodeProcessRecordIntoJson process =
    object
        [ ( "p_name", Encode.string process.p_name )
        , ( "burst_size", Encode.int process.burst_size )
        , ( "priority", Encode.int process.priority )
        ]


encodeListOfProcessesIntoJson : List CpuProcess -> ( String, Encode.Value )
encodeListOfProcessesIntoJson process_list =
    let
        list_of_values =
            List.map encodeProcessRecordIntoJson process_list

        list_of_encoded_strings =
            List.map (encode 0) list_of_values
    in
    ( "processes", Encode.list Encode.string list_of_encoded_strings )
