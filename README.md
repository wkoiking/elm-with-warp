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

