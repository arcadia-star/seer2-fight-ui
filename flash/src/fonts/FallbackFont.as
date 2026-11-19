package fonts {
import flash.display.Sprite;
import flash.text.Font;

public class FallbackFont extends Sprite {
    [Embed(source="/_assets/MSYH_CJK.ttf",
        fontName="fallback",
        mimeType="application/x-font-truetype")]
    private var FontClass:Class;

    public function FallbackFont() {
        Font.registerFont(FontClass);
    }
}
}
