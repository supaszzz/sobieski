package map;

import openfl.geom.Rectangle;

typedef NPCType = {
    interactionText : String,
    interactionFn : (npc : NPC) -> Void,
    width : Int,
    height : Int,
    asset : String
};

class NPC extends AnimatedTile {
    public static var types : Array<NPCType> = [];

    public var hitbox : Rectangle;
    public var type : NPCType;

    public function new(type : NPCType, x : Float, y : Float) {
        super(type.asset, type.width, type.height);
        this.x = x;
        this.y = y;
        this.type = type;

        this.hitbox = new Rectangle(x + 1, y + type.height / 2, type.width - 2, type.height / 2);
    }

    public function interact() {
        type.interactionFn(this);
        return type.interactionText;
    }

    public static function create(type : Int, x : Float, y : Float) {
        var npc = new NPC(types[type], x, y);
        return npc;
    }

    public static function register(id : Int, interactionText : String, interactionFn : (npc : NPC) -> Void, width : Int = 0, height : Int = 0, asset : String = "") {
        types[id] = {interactionText: interactionText, interactionFn: interactionFn, width: width, height: height, asset: asset};
    }

    public static function registerAll() {
        register(0, "ajajaja", npc -> {}, 32, 32, "assets/enemy/ptoszek.png");
    }
}