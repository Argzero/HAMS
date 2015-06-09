package hams;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.sound.Sound;
import flambe.util.Strings;
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
class SongManager extends Component
{
    // SongManager Index in AudioManager
    public var Index:Int;
    
	// If this is not the current active SongManager
	public var Active:Bool;
	
    // AudioManager Insta nce
    private var audio_m:AudioManager;
    
    // If the AudioManager is in Debug, so is this
    
    /**
     * Instantiates object. Multiple can be made by user and added to the AudioManager. Allows for multiple backing tracks
     * @param _audioManager AudioManager Singleton-like instance of the game's AudioManager
     */
    private function new(_audioManager:AudioManager) {
        if(AudioManager.debug){
            trace("SongManager instantiated!");
        }
    }
    
    // Runs each time update is called
    public function update() {
    }
    
    // Calls Audio object's Play based on string identifier as noted in the file StringMap
    public function Play():Void {
    }
    
    // Calls Audio object's Loop based on string identifier as noted in the file StringMap
    public function Loop():Void {
    }
}