package;

import openfl.text.TextFieldAutoSize;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.utils.Assets;
import openfl.text.TextFieldType;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextFormat;
import openfl.text.TextField;

class TextView extends TextField {
    public static var textFormats : Array<TextFormat>;
    private static var fontName : String;

    public function new(toPrint : String = "", x : Float = 0, y : Float = 0, format : Int = 0) {
        super();

        if (fontName == null) {
            fontName = Assets.getFont("assets/SHPinscher-Regular.otf").fontName;
            textFormats = [
                new TextFormat(fontName, 24, 0xFFFFFF),
                new TextFormat(fontName, 24, 0xFF9900),
            ];
        }

        background = false;
        border = false;
        defaultTextFormat = textFormats[format];
        embedFonts = true;
        mouseWheelEnabled = false;
        multiline = true;
        selectable = false;
        type = TextFieldType.DYNAMIC;
        wordWrap = false;
        autoSize = TextFieldAutoSize.LEFT;
        this.x = x;
        this.y = y;
        scaleX = 1/3;
        scaleY = 1/3;

        text = toPrint;
    }
}