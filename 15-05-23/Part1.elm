import Graphics.Element exposing (..)
import Time
import Signal exposing ((<~), (~))

fpsCap : Int
fpsCap = 30

main : Signal Element
main = render <~ Time.fps fpsCap

displayFPS : Float -> Element
displayFPS f = show <| "Current FPS: " ++ (toString <| round <| 1000 / f)

render : Float -> Element
render f = flow down
    [ displayFPS f ]
