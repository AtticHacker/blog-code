import Graphics.Element exposing (..)
import Signal exposing ((<~), (~))
import Task
import Time
import Keyboard
import Mouse

mouseBox : Signal.Mailbox Int
mouseBox = Signal.mailbox 0

spaceBox : Signal.Mailbox Int
spaceBox = Signal.mailbox 0

heavyBox : Signal.Mailbox Element
heavyBox = Signal.mailbox empty

port updateMouseBox : Signal (Task.Task x ())
port updateMouseBox = Signal.sampleOn Mouse.clicks
    <| (Signal.send mouseBox.address << ((+) 1)) <~ mouseBox.signal

port updateSpaceBox : Signal (Task.Task x ())
port updateSpaceBox = Signal.sampleOn Keyboard.space
    <| (Signal.send spaceBox.address << ((+) 1)) <~ spaceBox.signal

port updateHeavyBox : Signal (Task.Task x ())
port updateHeavyBox = Signal.sampleOn Mouse.clicks
    <| Signal.send heavyBox.address << show << heavy
    <~ ((+) <~ mouseBox.signal ~ spaceBox.signal)

fpsCap : Int
fpsCap = 30

displayFPS : Float -> Element
displayFPS f = show <| "Current FPS: " ++ (toString <| round <| 1000 / f)

heavy : Int -> List Int
heavy i = List.repeat 10000 i

main : Signal Element
main = render <~ Time.fps fpsCap
    ~ heavyBox.signal
    ~ mouseBox.signal
    ~ spaceBox.signal

render : Float -> Element -> Int -> Int -> Element
render f h mouse space = flow down
    [ displayFPS f
    , h
    , flow right [show "Mouse:", show mouse]
    , flow right [show "Space:", show space]
    ]
