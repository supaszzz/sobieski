package battle.enemies;

class EnemyOko extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 75, 5, 12, 99, "Oko",
            getTileset("assets/enemy/oko.png"),
            "Spuszczam Cie z oczu.",
            2
        );
    }
}