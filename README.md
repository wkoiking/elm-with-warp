Sample program for Elm with Haskell warp server.

[elminator](https://hackage.haskell.org/package/elminator) package is used for automatic generation of Elm types/encoder/decode from Haskell types.

# How to build and run

1. Execute below commands:

~~~
stack build
elm make elm-src/Main.elm
stack exec elm-with-warp-exe
~~~

2. Access: http://localhost:8080

# Development with ghci

Using reload command `:r` in ghci and `update :: IO ()` function defined 
in `app/DevelMain.hs`, you can spare the build time for development.e.g.

~~~
$ stack ghci
*Main CodeGen DevelMain Lib Type> :r
*Main CodeGen DevelMain Lib Type> update
~~~

The `update` command will:

1. compile `Main.elm` by `callCommand "elm make elm-src/Main.elm"`,
2. kill the previous server thread in ghci if any, and
3. start the new server thread in ghci
