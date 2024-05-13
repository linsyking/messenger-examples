module Lib.Resources exposing (allTexture, allSpriteSheets)

{-|


# Textures

@docs allTexture, allSpriteSheets

-}

import Dict
import Messenger.Render.SpriteSheet exposing (SpriteSheet)


{-| allTexture

A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Examples:

[
( "ball", "assets/img/ball.png" ),
( "car", "assets/img/car.jpg" )
]

-}
allTexture : List ( String, String )
allTexture =
    []


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
    Dict.empty
