package battle.enemies;

class EnemyAwaria extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 20, 2, 6, 45, "Awaria",
            getTileset("assets/enemy/bluescreen.png"),
            "Awaria zażegnana!",
            2
        );
    }
}