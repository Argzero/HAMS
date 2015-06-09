package hams;
import flambe.animation.AnimatedFloat;
import flambe.display.ImageSprite;
import flambe.display.SubTexture;
import flambe.input.Key;
import flambe.System;
import hams.SpriteChangeBehavior;
import hams.SpriteChangeBehavior.SpriteStates;
/**
 * Basic Enemy - Random Walk is current goal
 * @author Argzero
**/
class Enemy
{
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
        
        // Velocity set based on algorithm
        // @see http://gamedevelopment.tutsplus.com/tutorials/the-three-simple-rules-of-flocking-behaviors-alignment-cohesion-and-separation--gamedev-3444
        // alignment();
        // cohesion();
        // separation();
        
        sprite.x.animateBy(vX, 0.05);
        sprite.y.animateBy(vY, 0.05);
        
        // REMOVE THIS WHEN STEERING WORKS!
        sprite.x.animateTo(MouseX, 0.05);// temp
        sprite.y.animateTo(MouseY, 0.05);// temp
        
        // Sets animation states based on velocity
        if (vX + vY > 3) {
            setAnimationSprites();
        }
        
        // LOCKS THE POSITION INSIDE THE GAME WORLD
        if (sprite.x._ + sprite.getNaturalWidth() > System.stage.width - 3) {  
            sprite.x.animateTo(System.stage.width - 5 - sprite.getNaturalWidth(),0.01);
        
            vX = 0;
        }
        else if (sprite.x._< 3) {  
            sprite.x.animateTo(5, 0.01);
            
            vX = 0;
        }        
        else if (sprite.y._ + sprite.getNaturalHeight() > System.stage.height - 3) {  
            sprite.y.animateTo(System.stage.height - 5 - sprite.getNaturalHeight(),0.01);
         
            vY = 0;
        }
        else if (sprite.y._ < 3) {  
            sprite.y.animateTo(5, 0.01);
            
            vY = 0;
        }
        
        // amount to move sprite
        sprite.scaleY.animateTo(2*scale * FMath.sign(sprite.scaleX._),0.1);
    }
    
    /**
     * Sets Animation sprites: picks a section of the spritesheet to use as current animation
     */
    private function setAnimationSprites():Void {
        if (Math.abs(vX) > 1 && Math.abs(vX) > Math.abs(vY)) {
            if (vX > 0) { _currentStateArray = _spriteStates.walkingRight; }
            else { _currentStateArray = _spriteStates.walkingLeft; }           
        }
        else if(vY > 0){_currentStateArray = _spriteStates.walkingFront;}
        else if(vY < 0){_currentStateArray = _spriteStates.walkingBack;}
    }
}