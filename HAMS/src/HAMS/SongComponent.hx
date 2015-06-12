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
	public var tracks:StringMap<Audio>;
	public var volumes:StringMap<Float>;
	public var fadeout:StringMap<Float>;
	public var crossfade_threshold:Float = 1.0;

	private var audio_m:AudioManager;
	private var song_m:SongManager;
	
	public function new(_songManager:SongManager, _tracks:StringMap<Audio>) {
		tracks = _tracks;
		volumes = new StringMap<Float>();
	    for (x in _tracks.keys()) {
			_tracks.get(x).SetVolume(0.0);
			volumes.set(x, 0.0);
			fadeout.set(x, 1.0);
		}
		audio_m = AudioManager.GetInstance();
		song_m = _songManager;
	}
	
	public function update() : Void {
		if(song_m.Crossfade) 
			setFade();
		for (_x in tracks.keys()) {
			audio_m.SetVolume(_x, volumes.get(_x)*song_m.GetVolume()*fadeout.get(_x));
		}
	}
	
	public function Play(_vol:Float) : Void {
		for (x in tracks.keys()) {
			volumes.set(x, _vol);
			tracks.get(x).Play(_vol);
		}
	}

	public function Loop() : Void {
		for (x in tracks.keys()) {
			if(song_m.Crossfade) 
				tracks.get(x).Play(0.0);
			else
				tracks.get(x).Play(volumes.get(x));
		}
	}
	
	public function Stop() : Void {
		for (x in tracks.keys()) {
			tracks.get(x).Stop();
		}
	}

	private function setFade():Void{
		for (_x in tracks.keys()) {
			var _playback : Playback = AudioManager.GetPlayback(_x);
			if(_playback != null){
				var pos : Float = (_playback.position);
				var length : Float = AudioManager.get(_x).GetLength();
				var percent_fade = 1.0;

				if(length-pos < crossfade_threshold)
					percent_fade = Tools.map(length-pos, 0.0, crossfade_threshold, 0.0, 1.0);
				fadeout.set(_x,percent_fade);
			}
		}	
	}

	public function SetCrossfadeThreshold(_ct:Float, _sm:SongManager=null):Void{
		if(_sm!=song_m)
			throw "<ERROR msg = 'unauthorized use of SetCrossfadeThreshold, please include the reference of the song manager managing this component'>";
		crossfade_threshold = _ct;
	}
}
 
/*class SongComponent {
	public var states:StringMap<StringMap<Float>>;
	public var tracks:StringMap<Audio>;
	public var current_state:String;
	private var audio_m:AudioManager;
	private var song_m:SongManager;
	
	public function new(_songManager:SongManager, _tracks:StringMap<Audio>) {
		tracks = _tracks;
		var off_state = new StringMap<Float>();
	    for (x in _tracks.keys()) {
			off_state.set(x, 0.0);
			_tracks[x].SetVolume(0.0);
		}
		states.set("off", off_state);
		SetState("off");
		audio_m = AudioManager.GetInstance();
		song_m = _songManager;
	}
	public function SetState(_state:String):Void {
		var _volumes:StringMap<Float> = states.get(_state);	
		for (x in _volumes.keys()) {
			audio_m.SetVolume(_x, _volumes[x]*song_m.Volume);
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
}*/