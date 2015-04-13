package haxing;

import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;

class Main
{
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
            
        // Adds Player to the game
        var player = new Entity()
            //.add(new MoviePlayer(new Library(pack,"player")).loop("idle"))
            .add(new Sprite().setXY(System.stage.width, System.stage.height))
            .add(new Player());
        System.root.addChild(player);
    }

    private static function onSuccess (pack :AssetPack)
    {
        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));

        // Add a plane that moves along the screen --- REMOVED BUT LEFT AS COMMENTS FOR REFERENCE
        // var plane = new ImageSprite(pack.getTexture("plane"));
        // plane.x._ = 30;
        // plane.y.animateTo(200, 6);
        // System.root.addChild(new Entity().add(plane));
    }
}
