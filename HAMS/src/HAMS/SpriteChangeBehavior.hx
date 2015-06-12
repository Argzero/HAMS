package hams;
import flambe.animation.AnimatedFloat;
import flambe.animation.Behavior;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.SubTexture;
/**
 * @author YawarRaza7349
 */

/**
 * Defines the Array of Image Textures to use for animations
 */
typedef SpriteStates = {
    var walkingBack : Array<SubTexture>;
    var walkingFront : Array<SubTexture>;
    var walkingLeft : Array<SubTexture>;
    var walkingRight : Array<SubTexture>;
    var attackingBack : Array<SubTexture>;
    var attackingFront : Array<SubTexture>;
    var attackingLeft : Array<SubTexture>;
    var attackingRight : Array<SubTexture>;
}

// Behavior to manage Animation of an in-game object
class SpriteChangeBehavior implements Behavior {
    private static inline var TIME_BETWEEN_SPRITE_CHANGE = 0.5;
    private var _spriteChangeTimer: AnimatedFloat;
    public function new(spriteChangeTimer: AnimatedFloat) {
        _spriteChangeTimer = spriteChangeTimer;
    }
    public function update(dt) {
        var temp = _spriteChangeTimer._ + dt;
        if (temp > TIME_BETWEEN_SPRITE_CHANGE) {
            return temp - TIME_BETWEEN_SPRITE_CHANGE;
        }
        return temp;
    };
    public function isComplete() {
        return false;
    };
}