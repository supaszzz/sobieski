package;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import openfl.display.Tileset;
import openfl.display.Tilemap;

class AnimatedSprite extends Sprite {
    public var tile : AnimatedTile;
    public var tilemap : Tilemap;

    public function new(assetID : String, width : Int, height : Int) {
        super();
        tilemap = new Tilemap(
            width,
            height,
            new Tileset(Assets.getBitmapData(assetID)),
            false
        );
        var wTiles = Std.int(tilemap.tileset.bitmapData.width / width);
        var hTiles = Std.int(tilemap.tileset.bitmapData.height / height);
        for (j in 0...hTiles)
            for (i in 0...wTiles)
                tilemap.tileset.addRect(new Rectangle(
                    i * width,
                    j * height,
                    width,
                    height
                ));

        tile = new AnimatedTile();
        tilemap.addTile(tile);

        addChild(tilemap);
    }

    public function animate(fps : Float, beginId : Int, endId : Int, loops : Int) {
        tile.animate(fps, beginId, endId, loops);
    }

    public function destroy() {
        tile.destroy();
        parent.removeChild(this);
        removeChild(tilemap);
    }
}