package map;

import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import haxe.Json;
import openfl.display.Tileset;
import openfl.display.Tilemap;

typedef MapInfo = Array<{
    name : String,
    layers : Int,
    tileSize : UInt
}>;
typedef MapLayer = Array<Array<Int>>;
typedef MapData = Array<MapLayer>;

class Rooms {
    public static var tilesets : Array<Tileset> = [];
    public static var mapInfo : MapInfo;
    public static var mapData : Array<MapData> = [];

    public static function loadMaps() {
        mapInfo = Json.parse(Assets.getText("assets/map/maps.json"));
        for (map in mapInfo) {
            var bitmap = Assets.getBitmapData('assets/map/${map.name}/tiles.png');
            var wTiles = Std.int(bitmap.width / map.tileSize);
            var hTiles = Std.int(bitmap.height / map.tileSize);
            tilesets.push(new Tileset(bitmap, [
                for (i in 0...hTiles)
                    for (j in 0...wTiles)
                        new Rectangle(j * map.tileSize, i * map.tileSize, map.tileSize, map.tileSize)
            ]));

            var data : MapData = [];
            for (i in 0...map.layers) {
                var layerFile = Assets.getText('assets/map/${map.name}/$i.csv');
                var layer : MapLayer = layerFile.substr(0, layerFile.charAt(layerFile.length - 1) == '\n' ? layerFile.length - 1 : layerFile.length).split('\n').map(
                    i -> i.split(',').map(i -> Std.parseInt(i))
                );
                data.push(layer);
            }
            mapData.push(data);
        }
    }

    public static function load(id : Int) {
        var layers = mapData[id];
        var tileSize = mapInfo[id].tileSize;
        var tilemap = new Tilemap(layers[0][0].length * tileSize, layers[0].length * tileSize, tilesets[id], false);

        for (layer in layers)
            for (i in 0...layer.length)
                for (j in 0...layer[i].length) {
                    var tid = layer[i][j];
                    var tile = new Tile(tid & 0xfffffff, j * tileSize, i * tileSize);
                    tile.scaleX = 1.001;
                    tile.scaleY = 1.001;
                    tile.originX = tileSize >> 1;
                    tile.originY = tileSize >> 1;
                    tid >>= 29;
                    var diagonal = tid & 1 == 1;
                    tid >>= 1;
                    var vertical = tid & 1 == 1;
                    tid >>= 1;
                    var horizontal = tid & 1 == 1;
                    if (horizontal && vertical)
                        tile.rotation = 180;
                    else if (diagonal)
                        if (horizontal)
                            tile.rotation = 90;
                        else
                            tile.rotation = -90;
                    tilemap.addTile(tile);
                }

        return tilemap;
    }
    
}