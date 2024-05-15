module Lib.Resources exposing (allTexture, allSpriteSheets)

{-|


# Textures

@docs allTexture, allSpriteSheets

-}

import Dict
import Messenger.Render.SpriteSheet exposing (SpriteSheet)


{-| A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Examples:

[
( "ball", "assets/img/ball.png" ),
( "car", "assets/img/car.jpg" )
]

-}
allTexture : List ( String, String )
allTexture =
    [ ( "player", "assets/sheet.png" ) ]


{-| All sprite sheets.

Example:

    allSpriteSheets =
        Dict.fromList
            [ ( "spritesheet1"
              , [ ( "sp1"
                  , { realStartPoint = ( 0, 0 )
                    , realSize = ( 100, 100 )
                    }
                  )
                , ( "sp2"
                  , { realStartPoint = ( 100, 0 )
                    , realSize = ( 100, 100 )
                    }
                  )
                ]
              )
            ]

-}
allSpriteSheets : SpriteSheet
allSpriteSheets =
    Dict.fromList
        [ ( "player"
          , List.concat <|
                List.indexedMap
                    (\row colsize ->
                        List.map
                            (\col ->
                                ( String.fromInt row ++ "/" ++ String.fromInt col
                                , { realStartPoint = ( 32 * toFloat col, 32 * toFloat row )
                                  , realSize = ( 32, 32 )
                                  }
                                )
                            )
                        <|
                            List.range 0 colsize
                    )
                    playerSize
          )
        ]


playerSize : List Int
playerSize =
    [ 13
    , 8
    , 10
    , 10
    , 10
    , 6
    , 4
    , 7
    ]
