package battle;

import openfl.geom.Rectangle;
import openfl.utils.Assets;
import openfl.media.Sound;
import motion.Actuate;
import openfl.display.Tileset;
import openfl.display.Tile;

abstract class Enemy extends Tile {
    public var hp : Int;
    public var def : Int;
    public var atk : Int;
    public var name : String;
    public var battle : Battle;
    public var deathText : String;
    public var exp : Int;
    public var gender : String;

    private static var hitSound : Sound;

    public function new(battle: Battle, hp : Int, def : Int, atk : Int, exp : Int, name : String, tileset : Tileset, deathText : String, scale : Float = 1, gender : String = '') {
        super();
        if (hitSound == null) {
            hitSound = Assets.getSound("assets/sound/hit_enemy.wav");
        }
        this.tileset = tileset;
        this.hp = hp;
        this.def = def;
        this.atk = atk;
        this.exp = exp;
        this.name = name;
        this.battle = battle;
        this.deathText = deathText;
        this.gender = gender;
        scaleX = scaleY = scale;
    }

    public function die() {
        Actuate.tween(this, 1, {alpha: 0}).onComplete(() -> {
            battle.removeEnemy(this);
        });
    }

    public function genericAttack() : Int {
        return Std.int(Math.max(1, (Math.random() + 0.5) * atk - (battle.battleMain.blocking ? 2 : 1) * PlayerStats.def));
    }

    public function damage() {
        var currentX = x;
        var currentY = y;
        id = 1;
		Actuate.update((v : Float) -> {
			x = currentX + Math.sin(v)*(10 - v);
			y = currentY + Math.cos(v)*(10 - v);
		}, 1, [0], [10]).onComplete(() -> {
            id = 0;
        });
        if (hp <= 0)
            die();
        hitSound.play();
	}

    public function getTileset(id : String, size : Int = 32) : Tileset {
        return new Tileset(Assets.getBitmapData(id), [
            new Rectangle(0, 0, size, size),
            new Rectangle(0, size, size, size)
        ]);
    }

    public function turn() : String {
        battle.battleMain.damageQueue.add(genericAttack());
        return '$name atakuje!';
    }
}