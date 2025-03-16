package map;

import openfl.events.Event;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;

class PlayerSprite extends AnimatedSprite {
    public var controls : Array<Bool> = [false, false, false, false];
    public var speed = 2.0;

    private var wasMoving = true;

    public function new() {
        super("assets/player.png", 29, 30);

        Main.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        Main.globalStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
        addEventListener(Event.ENTER_FRAME, enterFrame);
    }

    private function enterFrame(e : Event) {
        var moving = false;
        if (controls[0]) {
            y -= speed;
            moving = true;
        }
        if (controls[1]) {
            x -= speed;
            moving = true;
        }
        if (controls[2]) {
            y += speed;
            moving = true;
        }
        if (controls[3]) {
            x += speed;
            moving = true;
        }

        if (moving && parent != null) {
            parent.x = Math.min(Math.max(428 - parent.width, - x + 214 - width / 2), 0);
            parent.y = Math.min(Math.max(240 - parent.height, - y + 120 - height / 2), 0);
        }

        if (wasMoving && !moving) {
            this.animate(5, 0, 2, 0);
        } else if (!wasMoving && moving) {
            this.animate(8, 4, 7, 0);
        }
        wasMoving = moving;
    }

    private function keyDown(e : KeyboardEvent) {
        switch (e.keyCode) {
            case Keyboard.W | Keyboard.UP:
                controls[0] = true;
            case Keyboard.A | Keyboard.LEFT:
                controls[1] = true;
            case Keyboard.S | Keyboard.DOWN:
                controls[2] = true;
            case Keyboard.D | Keyboard.RIGHT:
                controls[3] = true;
        }
    }
    private function keyUp(e : KeyboardEvent) {
        switch (e.keyCode) {
            case Keyboard.W | Keyboard.UP:
                controls[0] = false;
            case Keyboard.A | Keyboard.LEFT:
                controls[1] = false;
            case Keyboard.S | Keyboard.DOWN:
                controls[2] = false;
            case Keyboard.D | Keyboard.RIGHT:
                controls[3] = false;
        }
    }
}