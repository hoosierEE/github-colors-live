import Graphics.Element exposing (..)
import Task exposing (..)


hello : Signal.Mailbox String
hello =
  Signal.mailbox "loading"


main : Signal Element
main =
  Signal.map show hello.signal


port runHello : Task x ()
port runHello =
  (Task.succeed "Hello world") `andThen` Signal.send hello.address
