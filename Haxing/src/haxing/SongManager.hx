package haxing;
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
 * TOTAL LIST OF FUNCTIONALITY:
     * X Horizontal Resequencing
     * X Vertical Remixing
     * X Fade Out
     * X Fade In
     * X Crossfade Out
     * X Crossfade In
     * X Effects
 * 
 * KEY: X = not implemented; ++ Finished   
 * @author Argzero
 */
class SongManager extends Component
{
    // Collection of the Audio Files
    private var files_by_label:StringMap<String>;
    
    // SongManager Index in AudioManager
    public var Index:Int;
    
    // Collection of Audio indexed by the label given to them on creation
    private var audio_by_label:StringMap<Audio>;
    
    // AudioManager Instance
    private var audio_m:AudioManager;
    
    // If the AudioManager is in Debug, so it this
    
    /**
     * Instantiates object. Multiple can be made by user and added to the AudioManager. Allows for multiple backing tracks
     * @param _audioManager AudioManager Singleton-like instance of the game's AudioManager
     */
    private function new(_audioManager:AudioManager) {
        files_by_label = files;
        if (files_by_label == null) {
            files_by_label = new StringMap<String>();
        }
        assets = pack; 
        audio_by_label = _audioManager.GetAudio();
        files_by_label = _audioManager.GetFiles();
        
        if(AudioManager.debug){
            trace("SongManager instantiated!");
        }
    }
    
    // Runs each time update is called -- dt is not used
    override public function update() {
        audio_by_label = audio_m.GetAudio();
        files_by_label = audio_m.GetFiles();
        for(name in audio_by_label.keys()) {
            audio_by_label.get(name).update();
        }
    }
    
    // Loads files in the files_by_label collection into the audio_by_label collection
    public function load_files(_pack:AssetPack):Void {
        for (name in files_by_label.keys()) {
            if (AudioManager.debug) {
                trace(name + " has been added to the SongManager");
            }
            var _path = files_by_label.get(name);
            var sound = _pack.getSound(_path);
            audio_by_label.set(name, new Audio(name, sound, false, 0)); // DEFAULT VALUES UNTIL CUSTOMIZATION IS ADDED
        }
        files_by_label = new StringMap<String>();
    }
    
    // Calls Audio object's Play based on string identifier as noted in the file StringMap
    public function Play(_label:String, _volume:Float = 1):Void {
        audio_by_label.get(_label).Play(_volume);
    }
    
    // Calls Audio object's Loop based on string identifier as noted in the file StringMap
    public function Loop(_label:String, _volume:Float = 1):Void {
         audio_by_label.get(_label).Loop(_volume);
    }
}