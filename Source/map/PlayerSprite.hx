package map;

import openfl.geom.Rectangle;
import openfl.events.Event;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;

class PlayerSprite extends AnimatedTile {
    public var controls : Array<Bool> = [false, false, false, false];
    public var speed = 2.0;

    private var wasMoving = true;
    private var overworld : Overworld;
    public var thisRect : Rectangle;

    public var steps : Int = 0;

    public function new(ov : Overworld) {
        super("assets/player.png", 29, 30);
        overworld = ov;
        thisRect = new Rectangle();
        updateRect();
        Main.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        Main.globalStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
        Main.global.addEventListener(Event.ENTER_FRAME, enterFrame);
    }
    
    public override function destroy() {
        Main.globalStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
        Main.globalStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
        Main.global.removeEventListener(Event.ENTER_FRAME, enterFrame);

        super.destroy();
    }

    private function updateRect() {
        thisRect.x = x + 8;
        thisRect.y = y + 18;
        thisRect.width = 13;
        thisRect.height = 11;
    }

    public function collides() {
        updateRect();
        for (rect in overworld.currentRoom.collisionInfo) {
            if (rect.intersects(thisRect)) {
                return true;
            }
        }
        for (npc in overworld.currentRoom.npcLayer.npcs) {
            if (npc.hitbox.intersects(thisRect)) {
                return true;
            }
        }
        return false;
    }

    private function enterFrame(e : Event) {
        if (!overworld.focused) {
            animate(1, 0, 0, 0);
            return;
        }

        var moving = false;
        var prevX = x, prevY = y;
        if (controls[0]) {
            y -= speed;
            moving = true;
        }
        if (controls[2]) {
            y += speed;
            moving = true;
        }
        if (moving && collides()) {
            y = prevY;
        }
        
        if (controls[3]) {
            x += speed;
            moving = true;
        }
        if (controls[1]) {
            x -= speed;
            moving = true;
        }
        if (moving && collides()) {
            x = prevX;
        }

        if (moving) {
            var room = overworld.currentRoom;
            // steps++;
            if (steps > 100 && Math.random() < (steps / 300)) {
                steps = 0;
                Main.global.randEncounter();
            }
            room.x = Math.min(Math.max(428 - room.width, - x + 214 - width / 2), 0);
            room.y = Math.min(Math.max(240 - room.height, - y + 120 - height / 2), 0);
            overworld.currentRoom.npcLayer.sortY();
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