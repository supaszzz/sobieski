package battle;

import motion.Actuate;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.geom.Rectangle;
import openfl.display.Tileset;
import openfl.utils.Assets;
import openfl.display.Sprite;

class Battle extends Sprite {
    private var menuTile : Tile;
    private var hpTile : Tile;
    private var epTile : Tile;

    private var hpCounter : TextView;
    public var epCounter : TextView;

    public var ep = PlayerStats.maxEP;
    public var hpTarget = PlayerStats.hp;

    private var tilemap : Tilemap;
    private static var tileset : Tileset;

    private var timer : Timer;

    public var encounterText : String = "";

    private var battleBG : AnimatedSprite;

    public var battleMain : BattleMain;
    public var enemies : Array<Enemy> = [];

    public function new() {
        super();

        if (tileset == null) {
            tileset = new Tileset(Assets.getBitmapData("assets/hud/battle_hud.png"), [
                new Rectangle(0, 0, 64, 40),
                new Rectangle(0, 40, 15, 13),
                new Rectangle(15, 40, 15, 13)
            ]);
        }

        tilemap = new Tilemap(360, 240, tileset, false);

        menuTile = new Tile(0, 181, 180);
        hpTile = new Tile(1, menuTile.x + 8, menuTile.y + 15);
        epTile = new Tile(2, menuTile.x + 34, menuTile.y + 15);
        tilemap.addTile(menuTile);
        tilemap.addTile(hpTile);
        tilemap.addTile(epTile);

        hpCounter = new TextView(Std.string(PlayerStats.hp), menuTile.x + 24, menuTile.y + 15, 1);
        epCounter = new TextView(Std.string(ep), menuTile.x + 48, menuTile.y + 15, 1);

        battleBG = new AnimatedSprite("assets/hud/battle_bg.png", 428, 240);
        battleBG.alpha = 0.5;
        battleBG.animate(8, 0, 16, 0);

        addChild(battleBG);
        addChild(tilemap);
        addChild(hpCounter);
        addChild(epCounter);

        timer = new Timer(120, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();        
    }

    public function start() {
        battleMain = new BattleMain(this);
        addChild(battleMain);
    }

    public function addEnemy(enemy : Enemy, animated : Bool = false) {
        enemy.y = 130 - enemy.height / 2;
        this.enemies.push(enemy);
        alignEnemies(animated);
        tilemap.addTile(enemy);
    }
    public function removeEnemy(enemy : Enemy) {
        tilemap.removeTile(enemy);
        enemies.remove(enemy);
        alignEnemies(true);
    }

    private function alignEnemies(animated : Bool) {
        var fullWidth = 0.0;
        for (i in enemies)
            fullWidth += i.width;
        fullWidth += 8 * enemies.length - 1;
        var currentX = 213 - fullWidth / 2;
        for (i in enemies) {
            if (animated)
                Actuate.tween(i, 0.6, {x: currentX});
            else
                i.x = currentX;
            currentX += i.width + 8;
        }
    }

    private function onTimer(e : TimerEvent) {
        if (hpTarget > PlayerStats.hp) {
            PlayerStats.hp++;
        } else if (hpTarget < PlayerStats.hp) {
            PlayerStats.hp--;
        }
        hpCounter.text = Std.string(PlayerStats.hp);
    }

    public function rollHP(value : Int) {
        hpTarget += value;
        if (hpTarget <= 0) {
            hpCounter.defaultTextFormat = TextView.textFormats[2];
        } else {
            hpCounter.defaultTextFormat = TextView.textFormats[1];
        }
    }
}