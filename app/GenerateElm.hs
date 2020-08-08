module GenerateElmType where

import System.Process

update :: IO ()
update = callCommand "elm make elm-src/Main.elm"
