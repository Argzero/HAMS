package hams;
import hams.Scrollbar;
//import flambe.debug.FpsDisplay;
import flambe.display.Font;
import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.System.keyboard;
import haxe.ds.StringMap;
import flambe.input.Key;
import flambe.subsystem.KeyboardSystem;

class Main
{
    // Main function for the game
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity()
            .add(background));
        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("global");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess); 
        
        // Game BG Color added
        System.root.addChild(new Entity()
            .add(new FillSprite(0x29506d, System.stage.width, System.stage.height)));
    }
    public static var assetPack: AssetPack;
    /* Loads AssetPack into Game and Initializes the AudioManager, 
     * Player, and Enemy(UNIMPLEMENTED) class data
     * 
     * @param pack AssetPack returned when assets have loaded successfully
     */
    private static function onSuccess (pack :AssetPack)
    {   
        assetPack = pack;
        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity()
            .add(background));
        
        var remFont = new Font(pack, "Arial");        
        /*var fps = new Entity().add(new TextSprite(remFont, "0"));
        fps.add(new FpsDisplay());
        System.root.addChild(fps);*/ 
                
        var files = new StringMap<String>();
        files = new StringMap<String>();
        //files.set("bgm","deep_leaves/deep_leaves");
		files.set("drum", "fairy_jing/drum/drum");
		files.set("wind", "fairy_jing/wind/wind");
		files.set("p1", "fairy_jing/piano_1/piano_1");
		files.set("p2", "fairy_jing/piano_2/piano_2");
		files.set("hat", "fairy_jing/hat/hat");
        add_player(pack).audio = AudioManager.CreateInstance(pack, files);
        
        var audio_manager = new Entity()
            .add(AudioManager.GetInstance());
        System.root.addChild(audio_manager);
        
		// How to play a Single Piece of Audio on Loop
		// audio_manager.get(AudioManager).Loop("bgm", 0.7);
        
		// How to make a Vertically Remixed song
		var _sm:SongManager = AudioManager.GetInstance().CreateSongManager("fairy_jing");
		var _tracks:StringMap<Audio> = new StringMap<Audio>();
		_tracks.set("drum", AudioManager.get("drum"));
		_tracks.set("wind", AudioManager.get("wind"));
		_tracks.set("p1", AudioManager.get("p1"));
		_tracks.set("p2", AudioManager.get("p2"));
		_tracks.set("hat", AudioManager.get("hat"));
		_sm.AddSongComponent(0, new SongComponent(_sm, _tracks));

        // Setting your song to crossfade between tracks
        _sm.Crossfade = true;
        _sm.SetCrossfadeThreshold(2.0); // Sets the time before fadeout in seconds
		
		var _volume = 0.2;
		_sm.Loop(_volume);

        var ups = [Key.Q,Key.W,Key.E,Key.R,Key.T,Key.Y];
        var downs = [Key.A,Key.S,Key.D,Key.F,Key.G, Key.H];
		var _index = 0;
        for(t in _tracks.keys()){
            var s : Scrollbar = new Scrollbar(t, Scrollbar.SCROLL_BAR_TYPE.COMPONENT, _sm.GetName());
            s.up = ups.pop();
            s.down = downs.pop();
            var bar :Entity = new Entity().add(s);
            s.setXY(_index * (System.stage.width/(7)) + 0.5*(System.stage.width/(7)), 0);
            System.root.addChild(bar);
            _index++;
        }
        var _smb : Scrollbar = new Scrollbar(_sm.GetName(), SCROLL_BAR_TYPE.MANAGER);
        _smb.up = ups.pop();
        _smb.down = downs.pop();
        var m_bar :Entity = new Entity().add(_smb);
        _smb.setXY(_index * (System.stage.width/(7)) + 0.5*(System.stage.width/(7)), 0);
        System.root.addChild(m_bar);
          

        // How to access a SongManager by name
		// AudioManager.GetInstance().SongManagers.get("fairy_jing");
    }

    // Adds Player to the game
    private static function add_player(pack:AssetPack):Player{
        var spritesheet = pack.getTexture("Hero");
        var subtextures = spritesheet.split(8, 3);

        var player = new Entity()
            .add(new ImageSprite(subtextures[0]).setXY(System.stage.width/2, System.stage.height/2))
            .add(new Player( {
                walkingBack : subtextures.slice(0, 4),
                walkingFront : subtextures.slice(4, 8),
                walkingLeft : subtextures.slice(8, 12),
                walkingRight : subtextures.slice(12, 16),
                attackingLeft : subtextures.slice(16, 18),
                attackingRight : subtextures.slice(18, 20),
                attackingBack : subtextures.slice(20, 22),
                attackingFront : subtextures.slice(22, 24)
            }));
        System.root.addChild(player);
        return player.get(Player);
    }
}

#typedef SM = SongManager;
#typedef AM = AudioManager;