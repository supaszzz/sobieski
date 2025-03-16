package battle.enemies;

class EnemyPies extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 40, 5, 8, 50, "Kamienny Pies",
            getTileset("assets/enemy/pies.png", 24),
            "Wracam do stania przed szkola.",
            2
        );
    }
}