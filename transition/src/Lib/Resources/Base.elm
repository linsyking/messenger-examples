module Lib.Resources.Base exposing
    ( saveSprite
    , igetSprite
    , getTexture
    )

{-|


# Resource

There are many assets (images) in our game, so it's important to manage them.

In elm-canvas, we have to preload all the images before the game starts.

The game will only start when all resources are loaded.

If some asset is not found, the game will panic and throw an error (alert).

After the resources are loaded, we can get those data from globaldata.sprites.

@docs saveSprite
@docs igetSprite
@docs getResourcePath

-}

import Base exposing (Msg(..))
import Canvas.Texture as Texture exposing (Texture)
import Dict exposing (Dict)
import Lib.Resources.Sprites exposing (allTexture)


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
