module Scenes.Main.Components.GameGrid.Render exposing (renderWell)

import Canvas exposing (Renderable)
import Canvas.Settings exposing (fill)
import Color exposing (Color)
import Lib.Tetris.Grid as G
import Messenger.Render.Shape exposing (rect)
import Scenes.Main.Components.GameGrid.Base exposing (Data, EnvGameGrid)


renderBox : EnvGameGrid -> (Color -> Color) -> Color -> ( Int, Int ) -> Renderable
renderBox env fun c ( x, y ) =
    Canvas.shapes [ fill (fun c) ]
        [ rect env.globalData ( toFloat x * 30, toFloat y * 30 + 30 ) ( 30, 30 )
        ]


renderWell : EnvGameGrid -> Data -> Canvas.Renderable
renderWell env { scale, active, grid, position } =
    Canvas.group []
        (grid
            |> G.stamp (Tuple.first position) (floor (Tuple.second position)) active
            |> G.mapToList (renderBox env identity)
            |> (::)
                (Canvas.shapes [ fill (Color.rgb255 236 240 241) ]
                    [ rect env.globalData ( 0, 30 ) ( toFloat scale.width * 30, toFloat scale.height * 30 ) ]
                )
        )
