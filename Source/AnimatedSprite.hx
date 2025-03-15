package;

import openfl.display.Sprite;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import openfl.display.Tileset;
import openfl.display.Tile;
import openfl.display.Tilemap;

class AnimatedSprite extends Sprite {
    public var tile : Tile;
    public var tilemap : Tilemap;
    private var timer : Timer;

    private var beginId : Int;
    private var endId : Int;

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

        tile = new Tile(0);
        tilemap.addTile(tile);
        
        timer = new Timer(100, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);

        addChild(tilemap);
    }

    public function animate(fps : Float, beginId : Int, endId : Int, loops : Int) {
        timer.reset();
        timer.delay = 1000 / fps;
        timer.repeatCount = loops * (endId - beginId + 1);
        tile.id = beginId;
        this.beginId = beginId;
        this.endId = endId;
        if (beginId != endId)
            timer.start();
    }

    private function onTimer(e : TimerEvent) {
        if (tile.id == endId) {
            tile.id = beginId;
        } else {
            tile.id++;
        }
    }

    public function destroy() {
        timer.stop();
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
        parent.removeChild(this);
        removeChild(tilemap);
    }
}