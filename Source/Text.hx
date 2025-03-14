package;

import openfl.events.Event;
import openfl.media.SoundChannel;
import openfl.utils.Assets;
import openfl.media.Sound;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextFormat;

class Text extends TextView {
    private var timer : Timer;
    private var toPrint : String;
    private var charIndex : UInt = 0;

    private var paused : Bool = false;
    private var clear : Bool = false;
    private var skipping : Bool = false;

    private var currentFormat : TextFormat;

    private static var textSound : Sound;

    private var focus : Bool;

    private var endCallback : () -> Void;
    private var breakCallback : () -> Void;

    public function new(toPrint : String, focus : Bool, ?endCallback : () -> Void, ?breakCallback : () -> Void) {
        super();

        if (textSound == null) {
            textSound = Assets.getSound("assets/sound/text.wav");
        }

        currentFormat = defaultTextFormat;
        this.toPrint = toPrint;
        this.focus = focus;

        this.endCallback = endCallback;
        this.breakCallback = breakCallback;

        timer = new Timer(50, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();


        if (focus)
            Main.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }
    
    private function onKeyDown(e : KeyboardEvent) {
        switch (e.keyCode) {
            case Keyboard.Z | Keyboard.ENTER:
                paused = false;
                if (clear) {
                    text = "";
                    clear = false;
                }
                if (charIndex == toPrint.length) {
                    if (endCallback != null) endCallback();
                    destroy();
                }
            case Keyboard.X | Keyboard.SHIFT:
                skipping = true;
                onTimer(null);
        }
    }

    private function onTimer(e : TimerEvent) {
        while (true) {
            if (paused)
                return;

            var char : String = toPrint.charAt(charIndex);
            charIndex++;
            if (char == '%') {
                if (toPrint.charAt(charIndex) == '%') {
                    charIndex++;
                } else {
                    execEscape();
                    continue;
                }
            }
            
            if (charIndex == toPrint.length)
                paused = true;

            appendText(char);
            setTextFormat(currentFormat, text.length - 1, text.length);
            if (char == ' ' || char == '\n' || skipping)
                continue;
            textSound.play();
            break;
        }
    }

    private function execEscape() {
        var char : String = toPrint.charAt(charIndex);
        charIndex++;
        switch (char) {
            case 's':
                timer.delay = (Std.parseInt(toPrint.charAt(charIndex)) + 1)*50;
                charIndex++;
            case 'k':
                currentFormat = TextView.textFormats[Std.parseInt(toPrint.charAt(charIndex))];
                charIndex++;
            case 'p':
                paused = true;
                skipping = false;
            case 'c':
                paused = true;
                clear = true;
                skipping = false;
            case 'b':
                if (breakCallback != null) breakCallback();
        }
    }

    public function destroy() {
        if (parent != null) {
            parent.removeChild(this);
        }
        timer.stop();
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
        this.endCallback = null;
        this.breakCallback = null;
        if (focus)
            Main.globalStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    public static function print(obj : DisplayObjectContainer, str : String, x : Float = 0, y : Float = 0, focus : Bool = true, ?endCallback : () -> Void, ?breakCallback : () -> Void) : Text {
        var text : Text = new Text(str, focus, endCallback, breakCallback);
        text.x = x;
        text.y = y;
        obj.addChild(text);
        return text;
    }
}