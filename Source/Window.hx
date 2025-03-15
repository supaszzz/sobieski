package;

import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import openfl.display.Tilemap;
import openfl.display.Tileset;

class Window extends Sprite {
    private static var tileset : Tileset;
    private var tilemap : Tilemap;

    private var tiles : Array<Array<Tile>> = [];

    public function new(x : Float, y : Float, w : Int, h : Int) {
        super();
        if (tileset == null) {
            tileset = new Tileset(Assets.getBitmapData("assets/hud/dialog_border.png"), [
                for (i in 0...3)
                    for (j in 0...3)
                        new Rectangle(j * 8, i * 8, 8, 8)
            ]);
        }

        tilemap = new Tilemap(w * 16, h * 16, tileset, false);

        this.x = x;
        this.y = y;

        for (i in 0...w) {
            tiles[i] = [];
            for (j in 0...h) {
                var tile = new Tile(4, i * 8, j * 8);
                tiles[i][j] = tile;
                tilemap.addTile(tile);
            }
            tiles[i][0].id = 1;
            tiles[i][h -1].id = 7;
        }
        for (i in 1...(h - 1)) {
            tiles[0][i].id = 3;
            tiles[w - 1][i].id = 5;
        }
        tiles[0][0].id = 0;
        tiles[0][h - 1].id = 6;
        tiles[w - 1][0].id = 2;
        tiles[w - 1][h - 1].id = 8;

        addChild(tilemap);
    }
}