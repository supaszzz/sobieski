package battle;

import openfl.utils.Assets;
import openfl.media.Sound;
import battle.enemies.*;

class BattleGroup {
    public var enemies : Array<Class<Enemy>>;
    public var encounterText : String;
    public var minLevel : Int;
    public var music : Int;

    public static var battleMusic : Array<Sound> = [];
    public static var battleGroups : Array<BattleGroup> = [];

    public function new(encounterText : String, music : Int, minLevel : Int, enemies : Array<Class<Enemy>>) {
        this.enemies = enemies;
        this.encounterText = encounterText;
        this.music = music;
        this.minLevel = minLevel;
    }

    public function start() {
        var battle = new Battle(battleMusic[music]);
        battle.encounterText = encounterText;
        for (i in enemies) {
            battle.addEnemy(Type.createInstance(i, [battle]));
        }
        battle.start();
        return battle;
    }

    public static function register(id : Int, encounterText : String, music : Int, minLevel : Int, ...enemies : Class<Enemy>) {
        battleGroups[id] = new BattleGroup(encounterText, music, minLevel, enemies);
    }

    public static function encounter(id : Int) {
        if (id == -1) {
            var arr = battleGroups.filter(i -> i.minLevel <= PlayerStats.level);
            return arr[Math.floor(Math.random()*arr.length)].start();
        }
        return battleGroups[id].start();
    }

    public static function registerAll() {
        battleMusic.push(Assets.getSound('assets/music/testbattle.wav'));

        register(0, "Przylecialy ptoszki", 0, 2, EnemyAwaria);
        register(1, "Przylecialy ptoszki", 0, 1, EnemyBurger);
    }
}