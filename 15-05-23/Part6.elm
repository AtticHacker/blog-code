import Graphics.Element exposing (..)
import Signal exposing ((<~), (~))
import Time
import Mouse

fpsCap : Int
fpsCap = 30

displayFPS : Float -> Element
displayFPS f = show <| "Current FPS: " ++ (toString <| round <| 1000 / f)

heavy : Int -> List Int
heavy i = List.repeat 10000 i

type UpdateTick
    = TimeTick Float
    | MouseTick ()

type alias State =
    { fps : Float
    , clicks : Int
    , view :
        { heavy : Element
        }
    }

main : Signal Element
main = render <~ Signal.foldp update initState inputs

initState : State
initState =
    { fps = 0
    , clicks = 0
    , view =
        { heavy = show <| heavy 0
        }
    }

update : UpdateTick -> State -> State
update input state = case input of
    TimeTick fps -> {state | fps <- fps}
    MouseTick () -> let
        c = state.clicks
        v = state.view in
        { state
            | clicks <- c + 1
            , view  <- {v | heavy <- show <| heavy <| 1 + state.clicks }
            }
    _ -> state

inputs : Signal UpdateTick
inputs = Signal.mergeMany
    [ TimeTick <~ Time.fps fpsCap
    , MouseTick <~ Mouse.clicks
    ]

render : State -> Element
render state = flow down
    [ displayFPS state.fps
    , state.view.heavy
    , flow right [show "Mouse:", show state.clicks]
    ]
