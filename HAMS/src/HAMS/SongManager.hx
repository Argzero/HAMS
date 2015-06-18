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
	public var Crossfade: Bool = false;
    // If the AudioManager is in Debug, so is this
    
    /**
     * Instantiates object. Multiple can be made by user and added to the AudioManager. Allows for multiple backing tracks
     * @param _audioManager AudioManager Singleton-like instance of the game's AudioManager
     */
    public function new(_audioManager:AudioManager, _approachVolume:Float = 1.0) {
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
			Volume = Tools.LerpFloat(Volume, ApproachVolume, FadeSpeed);
			for (s in segments)
				s.update();
			if (Looping) {
				trace("Looping!");
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
			Volume = Tools.LerpFloat(Volume, 0, FadeSpeed);
	}

	public function GetVolume():Float{
		return Volume;
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
		if(!Looping)
			Play(_vol);
		else{
			if (SegmentCount() < 1) {
				trace("WARNING: Attempted to play empty SM");
				return;
			}
			segments.get(current_segment).Loop();
		}

		Looping = true;
		LoopFinished = false;
		Active = true;
    }
	
	public function onLoopFinished():Void {
		if (type == SMType.DEFAULT){
			trace("Loop RESET!");
			Loop();
		}
		else {
			// Change to another Track -- INCOMPLETE
		}
	}
	
	public function SetCrossfadeThreshold(_ct:Float):Void{
		if(!Crossfade){
			throw ("<SONGMANAGER name='" + Index + "' msg='Song is non-crossfade!'");
		}
		for(s in segments)
			s.SetCrossfadeThreshold(_ct,this);
	}

	public function AddSongComponent(_index:Int,_sc:SongComponent):Void {
		segments.set(_index, _sc);
	}
	
	public function SegmentCount():Int {
		var _count :Int = 0;
		for (k in segments.keys())
			_count++;
		return _count;
	}
	
	public function dispose():Void {
		
	}
}