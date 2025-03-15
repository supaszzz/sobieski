package battle;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import motion.Actuate;
import openfl.display.Tile;

class Selector extends Tile {
    private var battle : Battle;
    private var selected : Int;
    private var callback : (i : Int) -> Void;

    public function new(b : Battle, callback : (i : Int) -> Void) {
        super(3);
        battle = b;
        if (battle.enemies.length % 2 == 0) {
            selected = Math.random() < 0.5 ? 0 : (battle.enemies.length - 1);
        } else {
            selected = Math.floor(battle.enemies.length / 2);
        }
        y = 90 - height / 2;
        x = 213 - width / 2;

        this.callback = callback;

        Actuate.tween(this, 0.5, {y: y - 10}).repeat().reflect();
        updateX();
        Main.globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }

    private function updateX() {
        var enemy = battle.enemies[selected];
        var newX  = enemy.x + enemy.width/2 - 5.5;
        Actuate.tween(this, 0.2, {x: newX});

    }

    private function keyDown(e : KeyboardEvent) {
        switch (e.keyCode) {
            case Keyboard.LEFT | Keyboard.A:
                if (selected != 0) selected--;
            case Keyboard.RIGHT | Keyboard.D:
                if (selected != battle.enemies.length - 1) selected++;
            case Keyboard.Z | Keyboard.ENTER:
                destroy();
                callback(selected);
            case Keyboard.X | Keyboard.SHIFT:
                destroy();
                callback(-1);
        }
        updateX();
    }

    public function destroy() {
        Actuate.stop(this);
        parent.removeTile(this);
        Main.globalStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    }
}