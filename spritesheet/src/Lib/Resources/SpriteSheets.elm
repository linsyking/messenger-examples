module Lib.Resources.SpriteSheets exposing (allSpriteSheets)

{-|


# Sprite Sheets

@docs sampleSpriteSheet

-}

import Dict
import Lib.Render.SpriteSheet exposing (SpriteSheet)


{-| Add all your sprite sheets here.

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
