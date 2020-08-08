{-# Language OverloadedStrings #-}
{-# Language TemplateHaskell #-}

module CodeGen where

import Data.Proxy
import Elminator
-- import Data.Text.IO
import Data.Text
import Data.Aeson.Types ( defaultOptions )

import Type

elmSource :: Text
elmSource =
  $(generateFor Elm0p19 defaultOptions "Generated.Autogen" (Just "./elm-src/Generated/Autogen.elm") $ do
      include (Proxy :: Proxy ElmToHaskellMessage) $ Everything Mono
      include (Proxy :: Proxy HaskellToElmMessage) $ Everything Mono)
--       include (Proxy :: Proxy SingleRecCon) $ Everything Mono
--       include (Proxy :: Proxy SingleConOneField) $ Everything Mono
--       include (Proxy :: Proxy SingleRecConOneField) $ Everything Mono
--       include (Proxy :: Proxy TwoCons) $ Everything Mono
--       include (Proxy :: Proxy TwoRecCons) $ Everything Mono
--       include (Proxy :: Proxy BigCon) $ Everything Mono
--       include (Proxy :: Proxy BigRecCon) $ Everything Mono
--       include (Proxy :: Proxy MixedCons) $ Everything Mono
--       include (Proxy :: Proxy Comment) $ Everything Mono
--       include (Proxy :: Proxy WithMaybes) $ Everything Mono
--       include (Proxy :: Proxy WithSimpleMaybes) $ Everything Mono
--       include (Proxy :: Proxy (WithMaybesPoly (Maybe String) Float)) $
--         Definiton Poly
--       include
--         (Proxy :: Proxy (WithMaybesPoly (Maybe String) Float))
--         EncoderDecoder
--       include (Proxy :: Proxy (Phantom ())) $ Everything Poly
--       include (Proxy :: Proxy (TypeWithPhantom Float)) $ Everything Poly
--       include (Proxy :: Proxy RecWithList) $ Everything Mono
--       include (Proxy :: Proxy IndRecStart) $ Everything Mono
--       include (Proxy :: Proxy IndRec2) $ Everything Mono
--       include (Proxy :: Proxy IndRec3) $ Everything Mono
--       include (Proxy :: Proxy NTSingleCon) $ Everything Mono
--       include (Proxy :: Proxy NTSingleCon2) $ Everything Poly
--       include (Proxy :: Proxy Tuples) $ Everything Mono
--       include (Proxy :: Proxy NestedTuples) $ Everything Mono
--       include (Proxy :: Proxy (NestedTuplesPoly ())) $ Definiton Poly
--       include (Proxy :: Proxy (TypeWithExt ())) $ Everything Poly
--       include (Proxy :: Proxy (WithEmptyTuple ())) $ Everything Poly
--       include (Proxy :: Proxy (Phantom2 ())) $ Everything Poly
--       include (Proxy :: Proxy PhantomWrapper) $ Everything Poly)

-- The `generateFor` function accepts an elm version (Elm0p19 or Elm0p18), a value of type `Options` from the Aeson library
-- , a module name for the generated module, and an optional `FilePath` to which the generated source will be written to, and a `Builder` value.
-- The `Builder` is just a `State` monad that aggregates the configuration parameters from the include
-- calls. The first parameter of the include function is a `proxy` value that denotes the type that requires Elm code generation.
-- The second value is a value of type `GenOption` that selects which entities needs to be generation, and also selects if the
-- type generated at Elm should be polymorphic. It is defined as follows.

-- data GenOption
--   = Definiton PolyConfig  -- Generate Type definition in Elm. PolyConfig field decides if the type has to be polymorphic
--   | EncoderDecoder        -- Generate Encoder and Decoder in Elm
--   | Everything PolyConfig -- Generate both type definition, encoders and decoders. PolyConfig field decides if the type has to be polymorphic.
--
-- data PolyConfig
--   = Mono | Poly
