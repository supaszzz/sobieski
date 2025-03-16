package battle.enemies;

class EnemyBurger extends Enemy {
    public function new(battle : Battle) {
        super(
            battle, 15, 4, 5, 30, "Szalony Burger",
            getTileset("assets/enemy/burger.png", 24),
            "Cukierki sie skonczyly...",
            2.5
        );
    }
}