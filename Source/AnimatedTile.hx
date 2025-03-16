package;

import openfl.utils.Assets;
import openfl.events.TimerEvent;
import openfl.geom.Rectangle;
import openfl.utils.Timer;
import openfl.display.Tileset;
import openfl.display.Tile;

class AnimatedTile extends Tile {
    private var timer : Timer;

    private var beginId : Int;
    private var endId : Int;

    public function new(?assetID : String, ?width : Int, ?height : Int) {
        super(0);
        if (assetID != null) {
            tileset = new Tileset(Assets.getBitmapData(assetID));
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
        }
        
        timer = new Timer(100, 0);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    public function animate(fps : Float, beginId : Int, endId : Int, loops : Int) {
        timer.reset();
        timer.delay = 1000 / fps;
        timer.repeatCount = loops * (endId - beginId + 1);
        id = beginId;
        this.beginId = beginId;
        this.endId = endId;
        if (beginId != endId)
            timer.start();
    }

    private function onTimer(e : TimerEvent) {
        if (id == endId) {
            id = beginId;
        } else {
            id++;
        }
    }

    public function destroy() {
        timer.stop();
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
    }
}