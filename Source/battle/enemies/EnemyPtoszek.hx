package battle.enemies;

class EnemyPtoszek extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 8, 0, 4, 20, "Ptoszek",
            getTileset("assets/enemy/ptoszek.png"),
            "Ptoszek odfruwa.",
            2
        );
    }
}