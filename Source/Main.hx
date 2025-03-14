package;

import openfl.display.Stage;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var globalStage : Stage;

	public function new()
	{
		super();
		globalStage = stage;

		stage.window.resizable = false;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, globalKeyDown);

		Text.print(this, "%s1asdfa%k1asdsad%k0f%psadfasdfs%cadfsdf", 50);
	}

	public function globalKeyDown(e : KeyboardEvent) {
		if (e.keyCode == Keyboard.F11) {
			stage.window.fullscreen = !stage.window.fullscreen;
		}
	}
}
