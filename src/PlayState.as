package
{
	import org.flixel.*;
	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;


	public class PlayState extends FlxState
	{
		private var player:FlxSprite;
		
		private var wavesLayer1:FlxTilemap;
		private var wavesLayer2:FlxTilemap;

		private var platformLevel:PlatformLevel;
		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		private var allLayers:FlxGroup;

		// This is an Object that stores some information about each of our props. See below for
		// details.
		private var props:Object;		

		private var globalWidth:Number;
		private var globalHeight:Number;

		private	var cam:FlxCamera; 
		private var lightMask:LightMask;

 
		[Embed(source="../img/mer_1.png")] private var wavesImg1:Class;
		[Embed(source="../img/mer_2.png")] private var wavesImg2:Class;
		


		override public function create():void
		{

			allLayers = new FlxGroup();		 

			platformLevel = new PlatformLevel(allLayers);
			globalWidth = platformLevel.width;
			globalHeight = FlxG.height;
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xff444444;
			
			var wavesProps:Array = new Array (
				new SceneryImage(wavesImg2, 0.7, 1716, 100), 
				new SceneryImage(wavesImg1, 0.5, 1426, 50)
				);

			loadWaves(wavesProps, globalWidth, globalHeight);

			
			/* Flixel only checks for collisions within a fixed
			 * size to save on performance (smaller area to check
			 * for collisions = faster). Change the world bounds to
			 * tell flixel the area within which to check for
			 * collisions.  As long as the level is reasonably
			 * sized, this can easily be set once at the beginning
			 * of the level and forgotten.  If you have larger
			 * levels and are seeing a drop in performance, you can
			 * keep updating the world bounds to the visible area
			 * and freezing objects out of view. Updating the world
			 * bounds itself is a cheap operation.  */
			FlxG.worldBounds = new FlxRect(0, 0, globalWidth, globalHeight);
			
			trace("width: "+ globalWidth);
			trace("height: "+globalHeight);
			
			/* The camera won't travel beyond the limits defined
			 * here. Useful so that it won't travel to places the
			 * player isn't supposed to see (for example beyond the
			 * edge of the level in the demo). */
	

			// FlxG.camera.setBounds(0, 0, tilesLevel.width, FlxG.height);
			// FlxG.camera.follow(player);
			// FlxG.addCamera(FlxG.camera);

			player = new Player(100, 100); 
			add(player);
			var head:Head = new Head(player); 
			add(head);
			
			cam = FlxG.camera;
			cam.follow(player);
			cam.setBounds(0, 0, globalWidth, globalHeight);

			// Display mouse pointer
			FlxG.mouse.show();

			// Add the layers to the scene.
			add(allLayers);

			lightMask = new LightMask(head); 
			add(lightMask); 


		}

		private function loadWaves(imageProps:Array, mainLevelWidth:uint, mainLevelHeight:uint):void
		{

		  
			var nbRepeat:uint;
			var imgId:uint = 0;

			// Now we can load the sprite and do whatever we want with it. This is where all
			// the data we stored at the beginning is useful.

			for (imgId = 0; imgId < imageProps.length; imgId++) {
			  var curImg:SceneryImage = imageProps[imgId];
			  var curWaveLayer:FlxGroup = new FlxGroup();

			  for (nbRepeat = 0; nbRepeat < mainLevelWidth / curImg.width * 2; nbRepeat++) {
			    var sprite:FlxSprite = new FlxSprite(nbRepeat * curImg.width, mainLevelHeight - curImg.height);
			    sprite.loadGraphic(curImg.image);
			    sprite.scrollFactor.x = curImg.scrollFactor;
			    sprite.solid = false;
			    trace("wave sprite x:"+sprite.x+" y:"+sprite.y+" w:"+sprite.width+" h:"+sprite.height);
			    curWaveLayer.add(sprite);
			  }
			  allLayers.add(curWaveLayer);
			}
		}
		

		override public function update():void
		{
			//Updates all the objects appropriately
			super.update();

			// Flixel's collision detection is great, but for
			// large-area games (platformers, etc.) it's
			// impractical to hit test the whole area of the game
			// in every frame. Here is how to check for collisions
			// in ONLY the area of the screen that is currently in
			// the game's view. 
			// FlxU.setWorldBounds(-(FlxG.scroll.x), -(FlxG.scroll.y), FlxG.width, FlxG.height);
			

			trace("player x: "+player.x+" y:"+player.y);
			//Finally, bump the player up against the level
			FlxG.collide(platformLevel.tilesLevel,player);
			FlxG.collide(platformLevel.collideGroup,player);
			
			//Check for player lose conditions
			if(player.y > FlxG.height)
			{
				FlxG.resetState();
			}
		}
		
	}
}
