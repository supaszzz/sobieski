package battle;

import openfl.events.Event;
import openfl.display.Sprite;

class BattleMain extends Sprite {
    private var battle : Battle;
    private var encounterTextWindow : Window;
    private var actionSelectWindow : Window;

    private var actionSelectMenu : Menu;
    private var encounterText : Text;

    public var nextDamage : Int = 0;

    public var currentTurn : Int = 0;

    public function new(b : Battle) {
        super();
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

        beginTurn();
    }

    private function playerTurn(e : Event) {
        switch (actionSelectMenu.selectedItem) {
            case 0:
                print("atak");
            case 1:
                print("ult");
            case 2:
                print("itemy");
            case 3:
                print("blokada");
            case 4:
                print("ucieczka");
        }
        
    }

    public function beginTurn() {
        encounterText = Text.print(encounterTextWindow, battle.encounterText, 8, 8, false);
        actionSelectMenu.focused = true;
    }

    public function print(text : String, ?cb : () -> Void) { //-> endTurn, actionSelected
        if (encounterText != null) {
            encounterText.destroy();
            encounterText = null;
        }
        Text.print(encounterTextWindow, text, 8, 8, true, () -> {
            if (currentTurn == 0) {
                currentTurn++;
                print(battle.enemy.turn() + "%cTracisz " + nextDamage + "%b HP", () -> {
                    battle.hpTarget -= nextDamage;
                });
            } else {
                currentTurn = 0;
                beginTurn();
            }
        }, cb);

    }
}