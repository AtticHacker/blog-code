import Graphics.Element exposing (..)
import Time
import Signal exposing ((<~), (~))

fpsCap : Int
fpsCap = 30

displayFPS : Float -> Element
displayFPS f = show <| "Current FPS: " ++ (toString <| round <| 1000 / f)

main : Signal Element
main = render (show <| heavy 100) <~ Time.fps fpsCap

heavy : Int -> List Int
heavy i = List.repeat 10000 i

render : Element -> Float -> Element
render h f = flow down
    [ displayFPS f, h ]
