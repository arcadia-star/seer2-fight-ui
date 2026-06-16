mxmlc \
  -target-player 32 \
  -source-path src \
  -library-path lib/greensock-taomee.swc \
  -library-path lib/as3corelib.swc \
  -output out/FramePlayer.swf \
  src/FramePlayer.as

mv out/FramePlayer.swf /E/sync/seer2/res/ui