package hams;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.sound.Sound;
import flambe.util.Strings;
import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * Manages the Songs in the game. Allows for Horizontal Resequencing and
 * Vertical remixing. CrossFading is also allowed on its own.
 * Other fade types are planned to be implemented.
 * 
 * TOTAL LIST OF (Planned/Existing) FUNCTIONALITY:
     * X Horizontal Resequencing
     * X Vertical Remixing
     * X Crossfade Out
     * X Crossfade In
     * X Effects -- Stretch Goal!!!
 * 
 * KEY: X = not implemented; ++ Finished   
 * @author Argzero
 */
enum SMType {
	DEFAULT;
	HORIZONTAL_RESEQUENCING;
}
 
class SongManager
{
    // SongManager Index in AudioManager
    public var Index:String;
    
	// If this is not the current active SongManager
	public var Active:Bool;
	
    // AudioManager Instance
    private var audio_m:AudioManager;
    
	// Song Tracks 
	private var segments:IntMap<SongComponent>;
	private var current_segment:Int = 0;
	private var segment_queue:Array<Int>;
	
	private var Volume: Float = 0;
	private var ApproachVolume: Float = 0;
	private var Looping: Bool = false;
	private var LoopFinished: Bool = false;
	public var FadeSpeed: Float = 0.1;
	public var type:SMType = SMType.DEFAULT;
	
    // If the AudioManager is in Debug, so is this
    
    /**
     * Instantiates object. Multiple can be made by user and added to the AudioManager. Allows for multiple backing tracks
     * @param _audioManager AudioManager Singleton-like instance of the game's AudioManager
     */
    private function new(_audioManager:AudioManager, _approachVolume:Float = 1.0) {
        if(AudioManager.debug){
            trace("SongManager instantiated!");
        }
		segments = new IntMap<SongComponent>();
		ApproachVolume = _approachVolume;
		segment_queue = new Array<Int>();
		current_segment = 0;
    }
     
    // Runs each time update is called
    public function update() {
		if (Active){
			Volume = LerpFloat(Volume, ApproachVolume, FadeSpeed);
			for (s in segments)
				s.update();
			if (Looping) {
				var _loop_finished = true;
				for (t in (segments.get(current_segment)).tracks.keys()) {
					if (segments.get(current_segment).tracks.get(t).current_playback != null)
						_loop_finished = false;
				}
				
				if (_loop_finished)
					onLoopFinished();
			}
		}
		else
			Volume = LerpFloat(Volume, 0, FadeSpeed);
	}
    
	public function TurnOnHR() {
		type = SMType.HORIZONTAL_RESEQUENCING;
	}
	
    public function Play(_vol:Float = 1.0):Void {
		if (SegmentCount() < 1) {
			trace("WARNING: Attempted to play empty SM");
			return;
		}
		segments.get(current_segment).Play(_vol);
	}
    
    public function Loop(_vol:Float = 1.0):Void {
		if (SegmentCount() < 1){
			trace("WARNING: Attempted to play empty SM");
			return;
		}
		Looping = true;
		LoopFinished = false;
		Play(_vol);
    }
	
	public function onLoopFinished():Void {
		if (type == SMType.DEFAULT)
			Loop();
		else {
			// Change to another Track -- INCOMPLETE
		}
	}
	
	public function AddSongComponent(_index:Int,_sc:SongComponent):Void {
		segments.set(_index, _sc);
	}
	
	public function SegmentCount():Void {
		var _count :Int = 0;
		for (k in segments.keys())
			_count++;
		return _count;
	}
	
	public function dispose():Void {
		
	}
	
	// Moves float slightly closer to target value based on a specific amount of change
    public function LerpFloat(from:Float, to:Float, _amt:Float):Float { // FOR GENERAL FLOAT
        var increase = false;
        if (from < to) {
            increase = true;
        }
        else 
            increase = false;
        
        var value_to_go_to = from + _amt;
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