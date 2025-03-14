package;

import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.events.Event;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.geom.Rectangle;
import openfl.display.Tileset;
import openfl.utils.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class Battle extends Sprite {
    private var menuTile : Tile;
    private var hpTile : Tile;
    private var epTile : Tile;

    private var hpCounter : TextView;
    private var epCounter : TextView;

    public var ep = PlayerStats.maxEP;
    public var hpTarget = PlayerStats.hp;

    private var tilemap : Tilemap;
    private static var tileset : Tileset;

    private var timer : Timer;

    public var encounterText : String;

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

        addChild(tilemap);
        addChild(hpCounter);
        addChild(epCounter);

        timer = new Timer(120, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();

        var bla = new Menu([
            "asdfasdf",
            "asdfsadfsdfdsa",
            "ssaasasa",
            "ffff",
            "aaaaa"
        ], 2);
        bla.addEventListener(Menu.SELECT, (e : Event) -> {
            Text.print(this, bla.itemViews[bla.selectedItem].text);
        });
        addChild(bla);
    }

    private function onTimer(e : TimerEvent) {
        if (hpTarget > PlayerStats.hp) {
            PlayerStats.hp++;
        } else if (hpTarget < PlayerStats.hp) {
            PlayerStats.hp--;
        }
        hpCounter.text = Std.string(PlayerStats.hp);
    }
}