package map;

import openfl.display.TileContainer;

class NPCLayer extends TileContainer {
    public var playerSprite : PlayerSprite;
    public var npcs : Array<NPC> = [];

    public function new(ov : Overworld) {
        super();
        playerSprite = new PlayerSprite(ov);
        addTile(playerSprite);
    }
    public function sortY() {
        sortTiles((a, b) -> Std.int(a.y - b.y));
    }
    public function addNPC(npc : NPC) {
        npcs.push(npc);
        addTile(npc);
    }
}