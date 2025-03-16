package map;

import openfl.ui.Keyboard;
import openfl.geom.Rectangle;
import openfl.events.KeyboardEvent;
import motion.Actuate;
import openfl.display.Sprite;

class Overworld extends Sprite {
    public var currentRoom : Room;

    public var dialogBox : DialogBox;

    public var focused = false;

    public function new() {
        super();
        alpha = 0;
        setRoom(0);

        dialogBox = new DialogBox(this);
        addChild(dialogBox);
        
        Main.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }
    public function setRoom(id : Int) {
        if (currentRoom != null)
            currentRoom.destroy();
        currentRoom = Room.load(id, this);
        addChildAt(currentRoom, 0);
    }

    public function changeRoom(id : Int) {
        Actuate.tween(this, 0.4, {alpha: 0}).onComplete(() -> {
            setRoom(id);
            Actuate.tween(this, 0.4, {alpha: 1});
        });
    }

    private function keyDown(e : KeyboardEvent) {
        if (!focused)
            return;

        if (e.keyCode == Keyboard.Z || e.keyCode == Keyboard.ENTER) {
            var rect = new Rectangle();
            for (npc in currentRoom.npcLayer.npcs) {
                rect.copyFrom(npc.hitbox);
                rect.inflate(2, 2);
                if (rect.intersects(currentRoom.npcLayer.playerSprite.thisRect)) {
                    dialogBox.show(npc.interact());
                    break;
                }
            }
        }
    }
}