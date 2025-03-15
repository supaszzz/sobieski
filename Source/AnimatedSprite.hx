package;

import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import openfl.display.Tileset;
import openfl.display.Tile;
import openfl.display.Tilemap;

class AnimatedSprite extends Tilemap {
    private var tile : Tile;
    private var timer : Timer;

    private var beginId : Int;
    private var endId : Int;

    public function new(assetID : String, width : Int, height : Int) {
        super(
            width,
            height,
            new Tileset(Assets.getBitmapData(assetID)),
            false
        );
        var wTiles = Std.int(tileset.bitmapData.width / width);
        var hTiles = Std.int(tileset.bitmapData.height / height);
        for (j in 0...hTiles)
            for (i in 0...wTiles)
                tileset.addRect(new Rectangle(
                    i * width,
                    j * height,
                    width,
                    height
                ));

        tile = new Tile(0);
        addTile(tile);
        
        timer = new Timer(100, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
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
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
        parent.removeChild(this);
    }
}