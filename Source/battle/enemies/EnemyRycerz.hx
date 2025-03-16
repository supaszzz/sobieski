package battle.enemies;

class EnemyRycerz extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 50, 10, 15, 99, "Rycerz",
            getTileset("assets/enemy/rycerz.png"),
            "Odmaszerowal.",
            2
        );
    }
}