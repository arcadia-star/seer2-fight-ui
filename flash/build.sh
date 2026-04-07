mxmlc -target-player='32.0' -source-path src -library-path lib/greensock-taomee.swc -library-path lib/as3corelib.swc -output out/DemoPlayer.swf src/DemoPlayer.as
mxmlc -target-player='32.0' -source-path src -library-path lib/greensock-taomee.swc -library-path lib/as3corelib.swc -output out/FightPlayer.swf src/FightPlayer.as

mv out/DemoPlayer.swf ../public/demo/ -Force
mv out/FightPlayer.swf ../public/ -Force

