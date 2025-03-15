package battle;

import openfl.media.Sound;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.display.Sprite;

class BattleMain extends Sprite {
    private var battle : Battle;
    private var encounterTextWindow : Window;
    private var actionSelectWindow : Window;

    private var actionSelectMenu : Menu;
    private var encounterText : Text;

    public var damageQueue : List<Int>;
    public var playerQueue : List<Enemy>;

    private static var hitSound : Sound;

    public var blocking : Bool = false;

    public function new(b : Battle) {
        super();

        if (hitSound == null) {
            hitSound = Assets.getSound("assets/sound/hit.wav");
        }

        battle = b;
        encounterTextWindow = new Window(103, 8, 21, 8);
        actionSelectWindow = new Window(275, 8, 6, 8);
        addChild(encounterTextWindow);
        addChild(actionSelectWindow);

        actionSelectMenu = new Menu([
            "Atak",
            "ULT",
            "Przedmioty",
            "Blokuj",
            "Ucieczka"
        ]);
        actionSelectMenu.x = 8;
        actionSelectMenu.y = 6;
        actionSelectWindow.addChild(actionSelectMenu);

        actionSelectMenu.addEventListener(Menu.SELECT, playerTurn);

        damageQueue = new List();
        playerQueue = new List();

        beginTurn();
    }

    public function takeEP(ep : Int) : Bool {
        if (battle.ep < ep)
            return false;

        battle.ep -= ep;
        battle.epCounter.text = Std.string(battle.ep);
        return true;
    }

    public function damageEnemy(id : Int, value : Float, turnStr : String) {
        var enemy = battle.enemies[id];
        var damage = Std.int(Math.max(1, (Math.random() + 0.5) * value - enemy.def));
        enemy.hp -= damage;
        turnStr += '${enemy.name} traci $damage%b HP!';
        if (enemy.hp <= 0)
            turnStr += '\n${enemy.deathText}';

        playerQueue.add(enemy);
        return turnStr;
    }

    private function playerTurn(e : Event) {
        var turnStr  = "";
        blocking = false;
        switch (actionSelectMenu.selectedItem) {
            case 0:
                if (!takeEP(2)) {
                    print("Nie masz wystarczajaco EP, by atakowac!", true, beginTurn);
                    return;
                }
                turnStr += "atak\n";
                turnStr = damageEnemy(0, PlayerStats.atk, turnStr);
            case 1:
                if (!takeEP(7)) {
                    print("Nie masz wystarczajaco EP, by uzyc ULTa!", true, beginTurn);
                    return;
                }
                turnStr += "ult\n";
                for (i in 0...battle.enemies.length) {
                    if (i != 0)
                        turnStr += "%c";
                    turnStr = damageEnemy(i, PlayerStats.atk * 2.5, turnStr);
                }
            case 2:
                //asdfasdf
            case 3:
                turnStr += "Blokujesz atak!";
                battle.ep = Std.int(Math.min(battle.ep + 5, PlayerStats.maxEP));
                battle.epCounter.text = Std.string(battle.ep);
                blocking = true;
            case 4:
                turnStr += "Probujesz sie wydostac...\n";
                if (Math.random() < 0.5) {
                    turnStr += "Udalo sie!";
                    enemiesTurn(turnStr, true);
                    return;
                } else {
                    turnStr += "Nie wyszlo :(";
                }
        }
        enemiesTurn(turnStr);
    }

    private function enemiesTurn(turnStr : String, endBattle : Bool = false) {
        if (!endBattle) for (enemy in battle.enemies) {
            if (enemy.hp <= 0)
                continue;

            turnStr += '%c${enemy.turn()}\n';
            var dmg = damageQueue.last();
            turnStr += dmg == 0 ? 'Nie trafił${enemy.gender}!' : 'Tracisz ${dmg}%b HP!';
        }
        print(turnStr, true, endBattle ? beginTurn : beginTurn, () -> {
            if (!playerQueue.isEmpty()) {
                playerQueue.pop().damage();
                return;
            }
            battle.rollHP(-damageQueue.pop());
            Main.global.shakeScreen();
            hitSound.play();
        });

    }

    public function beginTurn() {
        encounterText = print(battle.encounterText, false);
        actionSelectMenu.focused = true;
        damageQueue.clear();
        playerQueue.clear();
    }

    public function print(text : String, focus : Bool = true, ?endCb : () -> Void, ?breakCb : () -> Void) {
        if (encounterText != null) {
            encounterText.destroy();
            encounterText = null;
        }
        return Text.print(encounterTextWindow, text, 8, 8, focus, endCb, breakCb);
    }
}