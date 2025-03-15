package battle;

import openfl.geom.Rectangle;
import openfl.utils.Assets;
import openfl.display.Tileset;

class EnemyPtoszek extends Enemy {
    private static var enemyTileset : Tileset;

    public function new(battle : Battle) {
        super(
            battle, 5, 2, 4, 60, "Ptoszek",
            getTileset(),
            "umar",
            2
        );
    }
    public function turn() : String {
        battle.battleMain.damageQueue.add(genericAttack());
        return "tura ptoszka";
    }

    private function getTileset() : Tileset {
        if (enemyTileset == null) {
            enemyTileset = new Tileset(Assets.getBitmapData("assets/enemy/ptoszek.png"), [
                new Rectangle(0, 0, 32, 32),
                new Rectangle(0, 32, 32, 32)
            ]);
        }
        return enemyTileset;
    }
}