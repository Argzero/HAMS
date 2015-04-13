package haxing;
import flambe.asset.AssetPack;
import flambe.util.Strings;

/**
 * @author Argzero
 */

// Manages the audio for the game entirely so as to have all calls to audio 
// occur in the manager
class AudioManager
{
    // Singleton-like object: current Instance of the AudioManager if it exists
    private static var Instance:AudioManager;    
    
    public static function GetInstance():AudioManager {
        if (AudioManager.Instance == null) {
            throw "Instance not initialized with Asset Pack. Unable to load content. Please initialize in the OnSuccess Method";
        }
        else return AudioManager.Instance;
    }
    
    /**
     * Singleton-like Implementation: Only one AudioManager should exist at any time.
     * - Caveat: When the AudioManager is first initialized it should always be
     *           given the pack and files params. 
     * 
     * @param pack AssetPack object passed from Main#OnSuccess(pack:AssetPack).
     * @param files Array<String> String array representing the names of the loaded 
     *              files. May be passed in as empty array to allow for dynamic 
     *              adding of audio to the manager.
     * @see Main
     * @see Main#OnSuccess(pack:AssetPack)
     */
    public static function CreateInstance(pack:AssetPack, files:Array<String>):AudioManager {
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
            throw "No expect files passed to AudioManager. Unable to Initialize. If you want to initialize without having initial files, please pass in an empty array";
        }
    }
    
    /**
     * Instantiates object. Hidden from user to allow AudioManager to control its own instantiation.
     * @param pack AssetPack object passed from Main#OnSuccess(pack:AssetPack).
     * @param files Array<String> Array of Strings representing the names of the loaded files. 
     */
    private function new(?pack:AssetPack, ?files:Array<String>) {
        
    }
}