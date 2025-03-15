package;

import openfl.events.Event;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;

class Menu extends Sprite {
    public var focused = true;
    public var selectedItem : Int;
    public var rows : Int;
    public var itemViews : Array<TextView> = [];

    public static final SELECT = "menuSelect";

    public function new(items : Array<String>, rows : Int = 64, selectedItem : Int = 0) {
        super();
        this.selectedItem = selectedItem;
        this.rows = rows;

        var currentY : Float = 0;
        var maxW : Float = 0;

        for (i in 0...items.length) {
            if (i % rows == 0)
                currentY = 0;
            var tv = new TextView(items[i], 0, currentY, selectedItem == i ? 1 : 0);
            currentY += tv.textHeight / 3;
            itemViews.push(tv);
            addChild(tv);
            if (tv.textWidth > maxW)
                maxW = tv.textWidth;
        }
        maxW = (maxW / 3) + 8;

        for (i in 0...items.length) {
            itemViews[i].x = Math.floor(i / rows) * maxW;
        }

        Main.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }

    private function keyDown(e : KeyboardEvent) {
        if (!focused)
            return;
        itemViews[selectedItem].defaultTextFormat = TextView.textFormats[0];
        switch (e.keyCode) {
            case Keyboard.W | Keyboard.UP:
                selectedItem--;
            case Keyboard.A | Keyboard.LEFT:
                selectedItem -= rows;
            case Keyboard.S | Keyboard.DOWN:
                selectedItem++;
            case Keyboard.D | Keyboard.RIGHT:
                selectedItem += rows;
            case Keyboard.Z | Keyboard.ENTER:
                dispatchEvent(new Event(SELECT));
                focused = false;
        }
        if (selectedItem < 0)
            selectedItem = 0;
        else if (selectedItem >= itemViews.length)
            selectedItem = itemViews.length - 1;
        itemViews[selectedItem].defaultTextFormat = TextView.textFormats[1];
    }

    public function destroy() {
        Main.globalStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        parent.removeChild(this);
    }
}