package;

import map.PlayerSprite;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import map.Overworld;
import battle.Battle;
import map.Room;
import battle.BattleGroup;
import openfl.utils.Assets;
import openfl.display.Bitmap;
import motion.Actuate;
import openfl.events.Event;
import openfl.system.Capabilities;
import openfl.display.Stage;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var globalStage : Stage;
	public static var global : Main;
	public static var scale : Float = 3;

	public var currentBattle : Battle;
	public var overworld : Overworld;

	public static final SCALE_CHANGE = "scaleChange";

	public function new()
	{
		super();
		globalStage = stage;
		global = this;
		BattleGroup.registerAll();
		Room.loadMaps();
		Battle.load();
		PlayerStats.defaultStats();

		stage.window.resizable = false;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, globalKeyDown);

		scaleX = scale;
		scaleY = scale;

		overworld = new Overworld();
		addChild(overworld);
		ovEnter();
	}

	public function encounter(id : Int = -1) {
		Actuate.tween(overworld, 0.5, {alpha: 0}).onComplete(() -> {
			currentBattle = BattleGroup.encounter(id);
			currentBattle.alpha = 0;
			addChild(currentBattle);
			Actuate.tween(currentBattle, 0.5, {alpha: 1});
		});
	}

	public function randEncounter() {
		var timer = new Timer(800, 1);
		overworld.focused = false;
		Battle.playerDeath.play();

		var bitmap = new Bitmap(Assets.getBitmapData("assets/encounter.png"));
		overworld.addChild(bitmap);
		bitmap.x = overworld.currentRoom.npcLayer.playerSprite.x + 22 + overworld.currentRoom.x;
		bitmap.y = overworld.currentRoom.npcLayer.playerSprite.y + overworld.currentRoom.y;
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, e -> {
			encounter();
			overworld.removeChild(bitmap);
		});
		timer.start();
	}

	public function globalKeyDown(e : KeyboardEvent) {
		if (e.keyCode == Keyboard.F11) {
			stage.window.fullscreen = !stage.window.fullscreen;
			scale = stage.window.fullscreen ? Capabilities.screenResolutionY / 240 : 3;
			scaleX = scale;
			scaleY = scale;
			dispatchEvent(new Event(SCALE_CHANGE));
		}
	}

	public function shakeScreen(power : Float = 1, speed : Float = 1, duration : Float = 1) {
		Actuate.update((v : Float) -> {
			x = Math.sin(v * speed * duration)*(20 - v*2)*power;
			y = Math.cos(v * speed * duration)*(20 - v*2)*power;
		}, duration, [0], [10]);
	}

	public function ovEnter() {
		Main.global.overworld.focused = true;
        Actuate.tween(Main.global.overworld, 0.7, {alpha: 1});
	}

	public function showGameOver() {
		var bitmap = new Bitmap(Assets.getBitmapData("assets/hud/game_over.png"));
		bitmap.alpha = 0;
		addChild(bitmap);
		Actuate.tween(bitmap, 0.6, {alpha: 1});
		Actuate.tween(bitmap, 0.6, {alpha: 0}, false).delay(2.5).onComplete(() -> {
			removeChild(bitmap);
			overworld.setRoom(0);
			PlayerStats.defaultStats();
			ovEnter();
		});
		
	}
}
