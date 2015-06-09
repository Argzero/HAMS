package hams;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.sound.Sound;
import flambe.util.Strings;
import haxe.ds.StringMap;

/**
 * Manages the audio for the game entirely so as to have all calls to audio 
 * occur in the manager. Some Placeholder comments.
 * @author Argzero
 */
class AudioManager extends Component
{
    // Singleton-like object: current Instance of the AudioManager if it exists
    private static var Instance:AudioManager;   
    
    // AssetPack passed from main
    public var assets:AssetPack;

    // Collection of the Audio Files
    private var files_by_label:StringMap<String>;
    
    // Collection of Audio indexed by the label given to them on creation
    private var audio_by_label:StringMap<Audio>;
    
    public var SongManagers:StringMap<SongManager>;

    // Whether the AudioManger should be running in debug or not
    public static var debug:Bool = true;
    
    // Gets the current singleton instance of the AudioManager object
    public static function GetInstance():AudioManager {
        if (AudioManager.Instance == null) {
            throw "Instance not initialized with Asset Pack. Unable to load content. Please initialize in the Main#OnSuccess Method";
        }
        else return AudioManager.Instance;
    }
    
    //********************************
    public function GetFiles():StringMap<String> {
        return files_by_label;
    }
    
    //********************************
    public function GetAudio():StringMap<Audio> {
        return audio_by_label;
    }
    
    /**
     * Singleton-like Implementation: Only one AudioManager should exist at any time.
     * - Caveat: When the AudioManager is first initialized it should always be
     *           given the pack and files params. 
     * 
     * @param pack AssetPack object passed from Main#OnSuccess(pack:AssetPack).
     * @param files StringMap<String> String array representing the names of the loaded 
     *              files. May be passed in as empty StringMap to allow for dynamic 
     *              adding of audio to the manager.
     * @see Main
     * @see Main#OnSuccess(pack:AssetPack)
     */
    public static function CreateInstance(pack:AssetPack, files:StringMap<String>):AudioManager {
        if (AudioManager.Instance == null && pack!=null && files!=null){
            AudioManager.Instance = new AudioManager(pack, files);
            return AudioManager.Instance;
        }
        else if (AudioManager.Instance != null) {
            throw "Only one instance of AudioManager may exist at a time!";
        }
        else if (pack == null) {
            throw "Assets not given to AudioManager; Unable to load audio assets.";
        }
        else {
            throw "No expected files passed to AudioManager.\nUnable to Initialize.\nIf you want to initialize without having initial files,\nplease pass in an empty array";
        }
    }
    
    //********************************
    public function CreateSongManager(name:String):SongManager {
        var song_manager = new SongManager(this);
        SongManagers.set(name, song_manager);
        return song_manager;
    }
    
    //********************************
    public function DeleteSongManagerAtIndex(name:String):Void {
        
    }
    
    //********************************
    public function DeleteSongManager(_sm:SongManager):Void {
        
    }
    
    /**
     * Instantiates object. Hidden from user to allow AudioManager to control its own instantiation.
     * @param pack AssetPack object passed from Main#OnSuccess(pack:AssetPack).
     * @param files StringMap<String> StringMap of Strings representing the names of the loaded files. 
     */
    private function new(pack:AssetPack, files:StringMap<String>) {
        files_by_label = files;
        if (files_by_label == null) {
            files_by_label = new StringMap<String>();
        }
        assets = pack; 
        audio_by_label = new StringMap<Audio>();
        load_files(pack);
        //pack.getSound("deep_leaves/deep_leaves");
        
        if(AudioManager.debug){
            trace("AudioManager instantiated!");
        }
    }
    
    // Runs each time update is called -- dt is not used
    override public function onUpdate(dt:Float) {
        for(name in audio_by_label.keys()) {
            audio_by_label.get(name).update();
        }
        for(name in SongManagers.keys()) {
            SongManagers.get(name).update();
        }
    }
    
    // Loads files in the files_by_label collection into the audio_by_label collection
    public function load_files(_pack:AssetPack):Void {
        for (name in files_by_label.keys()) {
            if (AudioManager.debug) {
                trace(name + " has been added to the AudioManager");
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
	
	public function SetVolume(_label:String, _volume:Float) {
		audio_by_label.get(_label).SetVolume(_volume);
	}
}