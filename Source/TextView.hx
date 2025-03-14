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

    public function new(toPrint : String = "") {
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
        defaultTextFormat = textFormats[0];
        embedFonts = true;
        mouseWheelEnabled = false;
        multiline = true;
        selectable = false;
        type = TextFieldType.DYNAMIC;
        wordWrap = false;
        autoSize = TextFieldAutoSize.LEFT;

        text = toPrint;
    }
}