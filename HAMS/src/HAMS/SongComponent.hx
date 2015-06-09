package hams;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.sound.Sound;
import flambe.util.Strings;
import haxe.ds.StringMap;
import flambe.animation.AnimatedFloat;
import flambe.sound.Playback;

/**
 * An object representing a segment of a song. This may be an entire song, or a part of a song with multiple tracks etc.
 * @author Argzero
 */
class SongComponent {
	public var states:StringMap<StringMap<Float>>;
	public var tracks:StringMap<Audio>;
	public var current_state:String;
	private var audio_m:AudioManager;
	public function new(_tracks:StringMap<Audio>) {
		tracks = _tracks;
		var off_state = new StringMap<Float>();
	    for (x in _tracks.keys()) {
			off_state.set(x, 0.0);
			_tracks[x].SetVolume(0.0);
		}
		states.set("off", off_state);
		SetState("off");
		audio_m = AudioManager.GetInstance();
	}
	public function SetState(_state:String):Void {
		var _volumes:StringMap<Float> = states.get(_state);	
		for (x in _volumes.keys()) {
			audio_m.SetVolume(_x, _volumes[x]);
		}
		current_state = _state;
	}
	
	public function Play(_state:String) {
		for (x in tracks.keys()) {
			tracks.get(x).Play();
		}
		SetState(_state);
	}
	
	public function Stop() {
		for (x in tracks.keys()) {
			tracks.get(x).Stop();
		}
	}
}