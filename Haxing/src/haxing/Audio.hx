package haxing;
import flambe.animation.AnimatedFloat;
import flambe.sound.Playback;
import flambe.sound.Sound;

/**
 * Manages Individual Sounds - Mostly placeholder comments; to be fixed.
 * @author Argzero
 */
class Audio
{
    private var sound:Sound;
    private var volume=0.0;
    
    // Current Returned playback from a play or loop call
    private var current_playback:Playback;
    // Speed at which to fade to the correct volume
    public var lerp_amt = 0.1;
    
    // Constructor
    public function new(_sound:Sound, _play:Bool = false, _loop:Bool = false, _volume:Float = 0) {
        sound = _sound;
        trace("audio created");
        if (_play) {
            current_playback = sound.play();
        }
        else if (_loop) {
            current_playback = sound.loop();
        }
    }
    
    // Runs every frame
    public function update():Void {
        if (current_playback != null) {
            trace (volume);
            current_playback.volume.animateTo(Lerp(current_playback.volume,volume, lerp_amt), 0.1);
            if (current_playback.complete._) {
                current_playback = null;                
            }
        }
    }
    
    // Plays sound
    public function Play(_volume:Float):Void {
        if (current_playback != null) { return; }
        volume=_volume;
        current_playback = sound.play();
    }
    
    // Loops sound 
    public function Loop(_volume:Float):Void {
        if (current_playback != null) { return; }
        volume=_volume;
        current_playback = sound.loop();
    }
    
    // Moves float slightly closer to target value based on a specific amount of change
    public function Lerp(from:AnimatedFloat, to:Float, _amt:Float):Float {
        var increase = false;
        if (from._ < to) {
            increase = true;
        }
        else 
            increase = false;
        
        var value_to_go_to = from._ + _amt;
        if (increase) {
            if (value_to_go_to > to) {
                value_to_go_to = to;
            }
        }
        else {
            if (value_to_go_to < to) {
                value_to_go_to = to;
            }
        }
        return value_to_go_to;
    }
}