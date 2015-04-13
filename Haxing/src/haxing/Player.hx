package haxing;
import flambe.Component;
import flambe.display.Sprite;
import flambe.System;
import flambe.math.FMath;

/**
 * @author Argzero
 * @author YawarRaza7349
 */

// Player class: Where player interactions affect the game-mode
class Player extends Component {
    // Runs at Instantiation
    public function new() {
        
    }    
    
    // Runs each time update is called
    override public function onUpdate(dt :Float) {
        var sprite = owner.get(Sprite);
        
        // MouseX & MouseY in game coordinates
        var MouseX = System.pointer.x;
        var MouseY = System.pointer.y;
        
        // Scales the sprite based on distance from the front of the screen (isometric-ish)
        var scale = 0.5 + 0.2 * sprite.y._/System.stage.height;
        
        // sprite.y or .x += (amount) to move sprite
        // sprite.scaleX or .scaleY = (scale * FMath.sign(sprite.scaleX._) for x) or (scale for y) -- prevents flipping the sprite from modifying the sprite's width
    }
}