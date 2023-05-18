module Lib.Resources.Base exposing
    ( getTexture
    , saveSprite
    , igetSprite
    , allTexture
    )

{-|


# Resource

There are many assets (images) in our game, so it's important to manage them.

In elm-canvas, we have to preload all the images before the game starts.

The game will only start when all resources are loaded.

If some asset is not found, the game will panic and throw an error (alert).

After the resources are loaded, we can get those data from globaldata.sprites.

@docs getTexture
@docs saveSprite
@docs igetSprite
@docs allTexture

-}

import Base exposing (Msg(..))
import Canvas.Texture as Texture exposing (Texture)
import Dict exposing (Dict)


{-| Get the path of the resource.
-}
getResourcePath : String -> String
getResourcePath x =
    "assets/" ++ x


{-| getTexture

Return all the textures.

-}
getTexture : List (Texture.Source Msg)
getTexture =
    List.map (\( x, y ) -> Texture.loadFromImageUrl y (TextureLoaded x)) allTexture


{-| saveSprite
-}
saveSprite : Dict String Texture -> String -> Texture -> Dict String Texture
saveSprite dst name text =
    Dict.insert name text dst


{-| igetSprite

Get the texture by name.

-}
igetSprite : String -> Dict String Texture -> Maybe Texture
igetSprite name dst =
    Dict.get name dst


{-| allTexture

A list of all the textures.

Add your textures here. Don't worry if your list is too long. You can split those resources according to their usage.

Examples:

[
( "ball", getResourcePath "img/ball.png" ),
( "car", getResourcePath "img/car.jpg" )
]

-}
allTexture : List ( String, String )
allTexture =
    []
