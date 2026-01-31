package fonts {
import flash.display.Sprite;
import flash.text.Font;

public class EmojiFont extends Sprite {
    [Embed(source="/assets/NotoEmoji-VariableFont_wght.ttf",
            fontName="emoji",
            mimeType="application/x-font-truetype")]
    private var FontClass:Class;

    public function EmojiFont() {
        Font.registerFont(FontClass);
    }
}
}
