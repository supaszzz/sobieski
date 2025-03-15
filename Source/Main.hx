package;

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

	public static final SCALE_CHANGE = "scaleChange";

	public function new()
	{
		super();
		globalStage = stage;
		global = this;
		BattleGroup.registerAll();

		stage.window.resizable = false;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, globalKeyDown);

		scaleX = scale;
		scaleY = scale;

		var b = BattleGroup.encounter(0);
		addChild(b);
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

	public function showGameOver() {
		var bitmap = new Bitmap(Assets.getBitmapData("assets/hud/game_over.png"));
		bitmap.alpha = 0;
		addChild(bitmap);
		Actuate.tween(bitmap, 0.6, {alpha: 1});
		Actuate.tween(bitmap, 0.6, {alpha: 0}, false).delay(2.5).onComplete(() -> {
			removeChild(bitmap);
		});
		
	}
}
