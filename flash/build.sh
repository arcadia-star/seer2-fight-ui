#!/bin/sh
set -eu
cd "$(dirname "$0")"
: "${AIR_SDK_HOME:?Set AIR_SDK_HOME to the AIR SDK directory}"

compile() {
  java "-Dflexlib=$AIR_SDK_HOME/frameworks" \
    -jar "$AIR_SDK_HOME/lib/mxmlc-cli.jar" \
    +configname=flex -target-player=32 \
    -source-path src \
    -external-library-path lib/playerglobal.swc \
    -library-path lib/greensock-taomee.swc \
    -library-path+=lib/as3corelib.swc \
    -warnings=false "-output=$2" "$1"
}

compile src/FightPlayer.as ../public/FightPlayer.swf
compile src/DemoPlayer.as ../public/demo/DemoPlayer.swf
compile src/fonts/FallbackFont.as ../public/FallbackFont.swf
