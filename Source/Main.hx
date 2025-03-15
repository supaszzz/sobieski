package;

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

		stage.window.resizable = false;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, globalKeyDown);

		scaleX = scale;
		scaleY = scale;

		var b = new battle.Battle();
		addChild(b);

		b.addEnemy(new battle.EnemyPtoszek(b));
		b.addEnemy(new battle.EnemyPtoszek(b));
		b.start();
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

	public function shakeScreen() {
		Actuate.update((v : Float) -> {
			x = Math.sin(v)*(20 - v*2);
			y = Math.cos(v)*(20 - v*2);
		}, 1, [0], [10]);
	}
}
