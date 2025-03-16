package map;

import openfl.display.Tilemap;
import openfl.display.Sprite;

class Overworld extends Sprite {
    public var currentRoom : Tilemap;
    public var playerSprite : PlayerSprite;

    public function new() {
        super();
        currentRoom = Rooms.load(0);
        playerSprite = new PlayerSprite();
        addChild(currentRoom);
        addChild(playerSprite);
    }
}