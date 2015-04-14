package haxing;
import flambe.animation.AnimatedFloat;
import flambe.animation.Behavior;
import flambe.animation.Ease.EaseFunction;
import flambe.Component;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.SubTexture;
import flambe.input.Key;
import flambe.subsystem.KeyboardSystem;
import flambe.System;
import flambe.math.FMath;
import flambe.util.Value;
import haxing.Player.SpriteChangeBehavior;

/**
 * @author Argzero
 * @author YawarRaza7349
 */

/**
 * Defines the Array of Image Textures to use for animations of the player instance
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

// Behavior to manage Animation of the Player class
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
    // private variables
    private var _spriteChangeTimer: AnimatedFloat;
    private var _currentIndex: Int;
    private var _currentStateArray: Array<SubTexture>;
    private var _spriteStates:SpriteStates;
    private var SLOW_DOWN_SPEED = 0.95;
    private var vX = 0.0;
    private var vY = 0.0;
    
    // public variables
    public var audio:AudioManager;
    
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
        
        vY *= SLOW_DOWN_SPEED;
        vX *= SLOW_DOWN_SPEED;
        
        var moving_right = false;
        var moving_left = false;
        
        if (System.keyboard.isDown(Key.Up)) {
            vY += -1;
        }
        if (System.keyboard.isDown(Key.Down)) {
            vY += 1;
        }
        if (System.keyboard.isDown(Key.Left)) {
            vX += -1;
            moving_left = true;
        }
        if (System.keyboard.isDown(Key.Right)) {
            vX += 1;
            moving_right = true;
        }
        sprite.x.animateBy(vX, 0.05);
        sprite.y.animateBy(vY, 0.05);
        
        if (Math.abs(vX) > 1 && Math.abs(vX) > Math.abs(vY)) {
            if (vX > 0) { _currentStateArray = _spriteStates.walkingRight; }
            else { _currentStateArray = _spriteStates.walkingLeft; }           
        }
        else if(vY > 0){_currentStateArray = _spriteStates.walkingFront;}
        else if(vY < 0){_currentStateArray = _spriteStates.walkingBack;}
        // amount to move sprite
        // sprite.scaleY = (scale * FMath.sign(sprite.scaleX._) for x) or (scale for y) -- prevents flipping the sprite from modifying the sprite's width
    }
}