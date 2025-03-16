package battle.enemies;

class EnemyPilki extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 10, 0, 3, 15, "Gang pilek GKS",
            getTileset("assets/enemy/pliki.png"),
            "Moze pozniej zagramy.",
            2
        );
    }
}