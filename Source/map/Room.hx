package map;

import openfl.display.TileContainer;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.utils.Assets;
import haxe.Json;
import openfl.display.Tileset;
import openfl.display.Tilemap;

typedef MapInfo = Array<{
    name : String,
    layers : Int,
    tileSize : UInt,
    collision : Array<UInt>,
    npcs : Array<{x : Int, y : Int, type : Int}>
}>;
typedef MapLayer = Array<Array<Int>>;
typedef MapData = Array<MapLayer>;

class Room extends Tilemap {
    public static var tilesets : Array<Tileset> = [];
    public static var mapInfo : MapInfo;
    public static var mapData : Array<MapData> = [];

    public var layers : Array<TileContainer> = [];
    public var npcLayer : NPCLayer;
    public var collisionInfo : Array<Rectangle> = [];

    public static function loadMaps() {
        NPC.registerAll();
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

    public function new(width: Int, height: Int, tileset: Tileset, ov : Overworld) {
        super(width, height, tileset, false);
        npcLayer = new NPCLayer(ov);
    }
    public function destroy() {
        parent.removeChild(this);
        npcLayer.playerSprite.destroy();
    }

    public static function load(id : Int, ov : Overworld) {
        var layers = mapData[id];
        var tileSize = mapInfo[id].tileSize;
        var tilemap = new Room(layers[0][0].length * tileSize, layers[0].length * tileSize, tilesets[id], ov);

        for (layer in layers) {
            var container = new TileContainer();
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
                    container.addTile(tile);
                    tile.x += tile.originX;
                    tile.y += tile.originY;
                    if (mapInfo[id].collision.contains(tile.id)) {
                        tilemap.collisionInfo.push(new Rectangle(j * tileSize, i * tileSize, tileSize, tileSize));
                    }
                }
            tilemap.addTile(container);
        }
        tilemap.addTile(tilemap.npcLayer);

        for (i in mapInfo[id].npcs) {
            tilemap.npcLayer.addNPC(NPC.create(i.type, i.x, i.y));
        }

        return tilemap;
    }
    
}