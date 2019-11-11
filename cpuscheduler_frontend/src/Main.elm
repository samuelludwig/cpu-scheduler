module Main exposing (Model)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Random



-- MAIN


main =
    Element.layout []
        (view initial_model)



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


type alias Randomizer =
    { number_of_processes : Int
    , lowest_burst_size : Int
    , highest_burst_size : Int
    }


type alias Model =
    { sim_parameter_record : SimParameters
    , sim_output_record : SimOutput
    , randomizer_record : Randomizer
    , seed : Random.Seed
    }


initial_model : ( Model, Cmd msg )
initial_model =
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
      , randomizer_record =
            { number_of_processes = 0
            , lowest_burst_size = 0
            , highest_burst_size = 0
            }
      , seed = Random.initialSeed 
      }
    , Cmd.none
    )



-- VIEW


view : ( Model, Cmd msg ) -> Element msg
view ( model, msg ) =
    headerRow


header : Element msg
header =
    el
        [ centerX
        , Font.color color_palatte.white
        , Font.size size_palatte.large
        ]
        (text "CPU Scheduler")

headerRow : Element msg
headerRow =
    row
        [ width fill
        , Background.color color_palatte.seafoam_green
        , alignTop
        , padding 30
        ]
        [ header ]

addProcessRow : Element msg
addProcessRow =
    row
        [ width fill
        , Background.color color_palatte.seafoam_green] []

processBurstSizePrompt : Element msg
processBurstSizePrompt =
    el
        [ Font.color color_palatte.white
        , Font.size size_palatte.normal
        ]
        (text "Process burst size:")

processBurstSizeEntry : Element msg
processBurstSizeEntry =
    Input.text
        { placeholder = text "32"
        , label = text "burst_size"
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
    { seafoam_green = (rgb255 113 238 184)
    , white = (rgb 255 255 255)
    }

-- UPDATE


type Msg
    = RandomInteger Int
    | AddProcess CpuProcess
    | RemoveProcess Int
    | AddRandomizerProcesses
    | CalculateSimOutput
    | ChangeAlgorithm
    | ChangeQuantum


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


setRandomizerNumberOfProcesses : Int -> Model -> Model
setRandomizerNumberOfProcesses number ({ randomizer_record } as model) =
    { model
        | randomizer_record = { randomizer_record | number_of_processes = number }
    }


setRandomizerLowestBurstSize : Int -> Model -> Model
setRandomizerLowestBurstSize number ({ randomizer_record } as model) =
    { model
        | randomizer_record = { randomizer_record | lowest_burst_size = number }
    }


setRandomizerHighestBurstSize : Int -> Model -> Model
setRandomizerHighestBurstSize number ({ randomizer_record } as model) =
    { model
        | randomizer_record = { randomizer_record | highest_burst_size = number }
    }


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


buildCpuProcessFromRandomizerParameters : Randomizer -> Model -> CpuProcess
buildCpuProcessFromRandomizerParameters randomizer model =
    let
        size =
            randomNumberBetweenXAndY randomizer.lowest_burst_size randomizer.highest_burst_size model

        pri =
            randomNumberBetween0And127 model
    in
    { p_name = "Pn", burst_size = size, priority = pri }


addProcessesToSimParameterRecordFromRandomizerFields : Randomizer -> Model -> Model
addProcessesToSimParameterRecordFromRandomizerFields randomizer ({ sim_parameter_record } as model) =
    let
        cpu_process =
            buildCpuProcessFromRandomizerParameters randomizer model
    in
    addProcessToSimParameterRecord cpu_process model
        |> setNewSeed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RandomInteger num ->
            ( model, Cmd.none )

        AddProcess cpu_process ->
            ( addProcessToSimParameterRecord cpu_process model, Cmd.none )

        RemoveProcess num ->
            ( removeProcessFromSimParameterRecord num model, Cmd.none )

        AddRandomizerProcesses ->
            ( model, Cmd.none )

        CalculateSimOutput ->
            ( model, Cmd.none )

        ChangeAlgorithm ->
            ( model, Cmd.none )

        ChangeQuantum ->
            ( model, Cmd.none )



-- COMMAND


randomNumberBetween0And127 : Model -> Int
randomNumberBetween0And127 model =
    Random.step generateRandomIntBetween0And127 model.seed |> Tuple.first


randomNumberBetweenXAndY : Int -> Int -> Model -> Int
randomNumberBetweenXAndY x y model =
    Random.step (generateRandomIntBetweenXAndY x y) model.seed |> Tuple.first
