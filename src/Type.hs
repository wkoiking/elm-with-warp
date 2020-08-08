{-# Language DeriveGeneric #-}
{-# Language DeriveAnyClass #-}

module Type where

import Elminator
import Data.Aeson
import GHC.Generics (Generic)

data ElmToHaskellMessage
    = UpdateCounterValue Int
    | RequestInitialValue
    deriving (Generic, FromJSON, ToJSON, ToHType)

data HaskellToElmMessage
    = CurrentCounterValue Int
    deriving (Generic, FromJSON, ToJSON, ToHType)
