package battle;

import openfl.utils.Assets;
import openfl.media.Sound;

class BattleGroup {
    public var enemies : Array<Class<Enemy>>;
    public var encounterText : String;
    public var music : Int;

    public static var battleMusic : Array<Sound> = [];
    public static var battleGroups : Array<BattleGroup> = [];

    public function new(encounterText : String, music : Int, enemies : Array<Class<Enemy>>) {
        this.enemies = enemies;
        this.encounterText = encounterText;
        this.music = music;
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

    public static function register(id : Int, encounterText : String, music : Int, ...enemies : Class<Enemy>) {
        battleGroups[id] = new BattleGroup(encounterText, music, enemies);
    }

    public static function encounter(id : Int) {
        return battleGroups[id].start();
    }

    public static function registerAll() {
        battleMusic.push(Assets.getSound('assets/music/testbattle.wav'));

        register(0, "Przylecialy ptoszki", 0, EnemyPtoszek, EnemyPtoszek);
        register(1, "Przylecial ptoszek", 0, EnemyPtoszek);
    }
}