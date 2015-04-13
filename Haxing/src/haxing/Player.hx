package haxing;
import flambe.animation.AnimatedFloat;
import flambe.animation.Behavior;
import flambe.Component;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.SubTexture;
import flambe.System;
import flambe.math.FMath;
import flambe.util.Value;
import haxing.Player.SpriteChangeBehavior;

/**
 * @author Argzero
 * @author YawarRaza7349
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

// Player class: Where player interactions affect the game-mode
class Player extends Component {
    private var _spriteChangeTimer: AnimatedFloat;
    private var _currentIndex: Int;
    private var _currentStateArray: Array<SubTexture>;
    
    private var _spriteStates:SpriteStates;
    
    // Runs at Instantiation
    public function new(spriteStates : SpriteStates) {
        _spriteStates = spriteStates;
        _currentIndex = 0;
        _currentStateArray = spriteStates.walkingFront;
        _spriteChangeTimer = new AnimatedFloat(0, function(next, prev) {
            if (next < prev) {
                ++_currentIndex;
                _currentIndex %= _currentStateArray.length;
            }
        });
        _spriteChangeTimer.behavior = new SpriteChangeBehavior(_spriteChangeTimer);
    }
    
    // Runs each time update is called
    override public function onUpdate(dt :Float) {
        var sprite = owner.get(ImageSprite);
        sprite.texture = _currentStateArray[_currentIndex];
        _spriteChangeTimer.update(dt);
        
        // MouseX & MouseY in game coordinates
        var MouseX = System.pointer.x;
        var MouseY = System.pointer.y;
        
        // Scales the sprite based on distance from the front of the screen (isometric-ish)
        var scale = 0.5 + 0.2 * sprite.y._/System.stage.height;
        
        // sprite.y or .x += (amount) to move sprite
        // sprite.scaleX or .scaleY = (scale * FMath.sign(sprite.scaleX._) for x) or (scale for y) -- prevents flipping the sprite from modifying the sprite's width
    }
}