package hams;
import flambe.animation.AnimatedFloat;
import flambe.sound.Playback;
import flambe.sound.Sound;

/**
 * Manages Individual Sounds - Mostly placeholder comments; to be fixed.
 * @author Argzero
 */
class Audio{
    private var name              :String;
	public var type               :String;
    private var sound             :Sound;
    private var volume            :Float = 0.0;
    private var muted             :Bool = false;
    private var length            :Float = 0.0;
    // Current Returned playback from a play or loop call
    public var current_playback  :Playback;
    // Speed at which to fade to the correct volume
    public var lerp_amt           :Float = 0.1;
    // Bool telling if the Sound was recently Looping or not
    public var looping            :Bool = false;
    // Bool telling if the Sound was recently Playing or not
    public var playing            :Bool = false;
    // previous position of sound's last playback (useful for loop-callbacks)
    public var last_position      :Float = -1.0;
    
    // Constructor
    public function new(_name:String, _sound:Sound, ?_play:Bool = false, ?_loop:Bool = false, _volume:Float = 0) {
        sound = _sound;
        name = _name;
        length = _sound.duration;
		type = "SOUND";
        if(AudioManager.debug){trace("<DEBUG msg='" + _name + " audio created'>");}
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
            if(AudioManager.debug){trace (volume);}
            current_playback.volume.animateTo(volume, lerp_amt); // lerp(current_playback.volume,volume, lerp_amt
            if (current_playback.complete._) {
                current_playback.dispose();
                current_playback = null;                
            }
            if (current_playback != null) {
                if (current_playback.position<last_position && looping) { // looped just now, now do thing
                    
                    if(AudioManager.debug){trace("<DEBUG msg='audio looped!'>");}
                }
                last_position = current_playback.position;
                if(AudioManager.debug){trace("<DEBUG msg='position: " + current_playback.position + "'>");}
            }
        }
        else {
            playing = false;
            looping = false;
        }
    }

    public function GetLength():Float{
        return length;
    }
    
	public function Stop() {
		current_playback.paused = true; // set to pause
		current_playback.dispose(); // stop sound and remove
	}
	
    // Plays sound
    public function Play(_volume:Float = 1.0):Void {
        if (current_playback != null) { return; }
        volume=_volume;
        current_playback = sound.play();
        current_playback.volume._ = _volume;
    }

    // Plays sound
    public function PlayFade(_volume:Float = 1.0):Void {
        if (current_playback != null) { return; }
        volume=_volume;
        current_playback = sound.play();
        current_playback.volume._ = 0;
    }
    
    // Loops sound 
    public function Loop(_volume:Float = 1.0):Void {
        if (current_playback != null) { return; }
        volume=_volume;
        current_playback = sound.loop();
    }
	
	public function GetVolume() :Float {
		return volume;
	}
	
	public function SetVolume(_volume:Float) :Void {
		volume = _volume;
	}

    public function SetVolumeNow(_volume:Float) :Void {
        volume = _volume;
        current_playback.volume.animateTo(_volume,0);
    }

    public function GetPlayback():Playback{
        return current_playback;
    }
}