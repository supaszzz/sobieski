package battle;

import openfl.utils.Assets;
import openfl.media.Sound;
import motion.Actuate;
import openfl.geom.ColorTransform;

class BattleBG extends AnimatedSprite {
    public static final DEFAULT_R = 0.275;
    public static final DEFAULT_G = 0.216;
    public static final DEFAULT_B = 0.686;

    public static var ultSound : Sound;

    public function new() {
        super("assets/hud/battle_bg.png", 428, 240);

        if (ultSound == null) {
            ultSound = Assets.getSound("assets/sound/ult.wav");
        }

        this.animate(8, 0, 16, 0);

        tile.colorTransform = new ColorTransform(DEFAULT_R, DEFAULT_G, DEFAULT_B, 0.7);
    }

    public function ult() : Void {
        var animation = new AnimatedSprite("assets/hud/ult0.png", 428, 240);
        addChild(animation);
        animation.animate(21, 0, 20, 1);
        animation.tile.colorTransform = new ColorTransform(0.8, 0.8, 0.0);

        Actuate.tween(animation, 0.25, {alpha: 0}).delay(1).onComplete(() -> animation.destroy());
        Actuate.tween(tile.colorTransform, 1, {redMultiplier: 0.165, greenMultiplier: 0.502, blueMultiplier: 0.725, alphaMultiplier: 1.0}).onComplete(() -> {
            Main.global.shakeScreen(3, 2, 3);
            Actuate.tween(tile.colorTransform, 1, {redMultiplier: DEFAULT_R, greenMultiplier: DEFAULT_G, blueMultiplier: DEFAULT_B, alphaMultiplier: 0.7}).delay(3);
        });
        ultSound.play();
    }
}