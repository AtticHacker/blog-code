import Graphics.Element exposing (..)
import Time
import Signal exposing ((<~), (~))

fpsCap : Int
fpsCap = 30

main : Signal Element
main = render <~ Time.fps fpsCap

displayFPS : Float -> Element
displayFPS f = show <| "Current FPS: " ++ (toString <| round <| 1000 / f)

heavy : Int -> List Int
heavy i = List.repeat 10000 i

render : Float -> Element
render f = flow down
    [ displayFPS f, show <| heavy 100 ]
