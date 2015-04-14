package haxing;
import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.System.keyboard;
import haxe.ds.StringMap;

class Main
{
    // Main function for the game
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();
        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess); 
        
        // Game BG Color added
        System.root.addChild(new Entity()
            .add(new FillSprite(0x29506d, System.stage.width, System.stage.height)));
    }

    /* Loads AssetPack into Game and Initializes the AudioManager, 
     * Player, and Enemy(UNIMPLEMENTED) class data
     * 
     * @param pack AssetPack returned when assets have loaded successfully
     */
    private static function onSuccess (pack :AssetPack)
    {
        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));
        
        var spritesheet = pack.getTexture("Hero");
        var subtextures = spritesheet.split(8, 3);
        
        // Adds Player to the game
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
        
        var files = new StringMap<String>();
        files = new StringMap<String>();
        files.set("bgm","deep_leaves/deep_leaves");
        player.get(Player).audio = AudioManager.CreateInstance(pack, files);
        
        var audio = new Entity()
            .add(AudioManager.GetInstance());
        System.root.addChild(audio);
        audio.get(AudioManager).Loop("bgm", 0.7);
        
        trace("onsuccess COMPLETE");
        // LEFT FOR DOCUMENTATION PURPOSES AND FOR REFERENCE
        // Add a plane that moves along the screen
        // var plane = new ImageSprite(pack.getTexture("plane"));
        // plane.x._ = 30;
        // plane.y.animateTo(200, 6);
        // System.root.addChild(new Entity().add(plane));
    }
}