package hams;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.System;
import flambe.display.ImageSprite;
import flambe.System.keyboard;
import flambe.input.Key;
import flambe.subsystem.KeyboardSystem;
enum SCROLL_BAR_TYPE {
    COMPONENT;
    MANAGER;
}
class Scrollbar extends ImageSprite
{
    public var type : SCROLL_BAR_TYPE = SCROLL_BAR_TYPE.COMPONENT;
    public var key  : String = "";
    public var song_m: SongManager = null;
    public var top:Float = 0;
    public var position:Float = 0;
    public var bottom:Float = System.stage.height;
    public var component :SongComponent = null;
    public static var MASTER_UP : Key = Key.Up;
    public static var MASTER_DOWN : Key = Key.Down;
    public var up : Key = null;
    public var down : Key = null;
    public function new(_key:String, _type:SCROLL_BAR_TYPE, _songManagerName:String = ""){
        key = _key;
        type = _type;
        if(type == SCROLL_BAR_TYPE.COMPONENT){
            song_m = AudioManager.GetInstance().SongManagers.get(_songManagerName);
        }
        else if(type == SCROLL_BAR_TYPE.MANAGER){
            song_m = AudioManager.GetInstance().SongManagers.get(_key);
        }
        var tex : flambe.display.Texture = Main.assetPack.getTexture("box");
        bottom = System.stage.height - tex.height - 100;
        super(tex);
    }

    public function GetVolume() : Float{
        if(type == SCROLL_BAR_TYPE.MANAGER)
            return song_m.GetVolume();
        else{
            component = song_m.GetCurrentSegment();
            return component.GetTrackVolume(key);
        } 
        return -1;
    }

    public function SetVolume(_vol:Float):Void{
        if(_vol<0)
            _vol = 0;
        if(type == SCROLL_BAR_TYPE.MANAGER)
            return song_m.SetVolume(_vol);
        else{
            component = song_m.GetCurrentSegment();
            return component.SetTrackVolume(key,_vol);
        } 
    }

    // Runs each time update is called -- dt is not used
    override public function onUpdate(dt:Float) {
        SetVolume(Tools.map(position,top,bottom,1,0));
        this.y._ = (1 - (Tools.map(position,top,bottom,1,0)))* (bottom - top);
        trace("VOLUME: " + GetVolume());
        // Velocity increase due to player input
        if (System.keyboard.isDown(up)) {
            position -= System.stage.height*0.01;
            if(position < top)
                position = top;
        }
        if (System.keyboard.isDown(down)) {
            position += System.stage.height*0.01;
            if(position > bottom)
                position = bottom;
        }
        if (System.keyboard.isDown(Scrollbar.MASTER_UP)) {
            position -= System.stage.height*0.01;
            if(position < top)
                position = top;
        }
        if (System.keyboard.isDown(Scrollbar.MASTER_DOWN)) {
            position += System.stage.height*0.01;
            if(position > bottom)
                position = bottom;
        }
    }
}