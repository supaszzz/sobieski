package battle;

import openfl.display.Tileset;
import openfl.display.Tile;

abstract class Enemy extends Tile {
    public var maxHP : Int;
    public var hp : Int;
    public var def : Int;
    public var name : String;
    public var battle : Battle;
    public var deathText : String;

    public function new(battle: Battle, hp : Int, def : Int, name : String, tileset : Tileset, deathText : String, encounterText : String, scale : Float = 1) {
        super();
        this.tileset = tileset;
        maxHP = hp;
        this.hp = hp;
        this.def = def;
        this.name = name;
        this.battle = battle;
        this.deathText = deathText;
        battle.encounterText = encounterText;
        scaleX = scaleY = scale;
        x = 213 - width / 2;
        y = 130 - height / 2;
    }

    abstract public function turn() : String;
}