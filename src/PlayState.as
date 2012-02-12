package
{
	import org.flixel.*;
//	import com.adobe.serialization.json.*;


	public class PlayState extends FlxState
	{
		private var mainPlayer:FlxSprite;
		private var tilesLevel:FlxTilemap;
		
		private var wavesLayer1:FlxTilemap;
		private var wavesLayer2:FlxTilemap;

		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		public var allLayers:FlxGroup;

		// This is an Object that stores some information about each of our props. See below for
		// details.
		private var props:Object;		

		[Embed(source="props.json",       mimeType="application/octet-stream")] private var prop_data:Class;

		[Embed(source="tiles_map.txt", mimeType="application/octet-stream")] private var levelFile:Class;
		[Embed(source="waves1_layer.txt", mimeType="application/octet-stream")] private var waves1File:Class;
		[Embed(source="waves2_layer.txt", mimeType="application/octet-stream")] private var waves2File:Class;

		[Embed(source="myTiles.png")] private var myTyles:Class;
		[Embed(source="waves1.png")] private var wavesImg1:Class;
		[Embed(source="waves2.png")] private var wavesImg2:Class;
		
		override public function create():void
		{

			allLayers = new FlxGroup();		 

			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0x00aaaaaa;
			
			//Create a new tilemap using our level data
			tilesLevel = new FlxTilemap();
			tilesLevel.loadMap(new levelFile, myTyles ,10,10,0);
			//level.loadMap(new level_file, FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
			allLayers.add(tilesLevel);



			loadWaves();

			
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
			FlxG.worldBounds = new FlxRect(0, 0, tilesLevel.width, tilesLevel.height);
			trace("width: "+tilesLevel.width);
			trace("height: "+tilesLevel.height);
			
			/* The camera won't travel beyond the limits defined
			 * here. Useful so that it won't travel to places the
			 * player isn't supposed to see (for example beyond the
			 * edge of the level in the demo). */
	

			FlxG.camera.setBounds(0, 0, tilesLevel.width, tilesLevel.height);
			
			//Create player (a red box)
			mainPlayer = new FlxSprite(15, 15);
			mainPlayer.makeGraphic(10,12,0xffaa1111);
			mainPlayer.maxVelocity.x = 200;
			mainPlayer.maxVelocity.y = 200;
			mainPlayer.acceleration.y = 200;
			mainPlayer.drag.x = mainPlayer.maxVelocity.x*4;
			add(mainPlayer);
			
			var cam:FlxCamera = new FlxCamera(0,0, FlxG.width, FlxG.height); // we put the first one in the top left corner
			cam.follow(mainPlayer);
			// this sets the limits of where the camera goes so that it doesn't show what's outside of the tilemap
			cam.setBounds(0,0,tilesLevel.width, tilesLevel.height);
			FlxG.addCamera(cam);

			// Display mouse pointer
			FlxG.mouse.show();

			// Add the layers to the scene.
			add(allLayers);

		}

		private function loadWaves():void
		{

			// We need to put all of our prop images into a data structure that is compatible with
			// the Flevel data. Essentially, we just need to associate each prop's name with its image
			// and any other important data.
			props = {
				"waves1": { image: wavesImg1, scrollFactor: 0.5, width: 100, height: 20 }
				//"waves2": { image: wavesImg2, scrollFactor: 0.7, width: 100, height: 20 }
			};
			var nbRepeat:uint;
			var imgId:uint = 0;

			// Now we can load the sprite and do whatever we want with it. This is where all
			// the data we stored at the beginning is useful.

			for each (var curImg:Object in props) {
			  //			var curImg:Object      = props["waves1"];
			  var curWaveLayer:FlxGroup = new FlxGroup();

			  for (nbRepeat = 0; nbRepeat < 1100 / curImg.width * 2; nbRepeat++) {
			    var sprite:FlxSprite = new FlxSprite(nbRepeat * curImg.width, 480 - curImg.height);
			    sprite.loadGraphic(curImg.image);
			    sprite.scrollFactor.x = curImg.scrollFactor;
			    // Set the sprite properties from the flevel data.
			    //sprite.angle   = prop.angle;
			    //sprite.scale.x = sprite.scale.y = prop.scale;
			    // Add the prop to the layer group.
			    curWaveLayer.add(sprite);
			  }
			allLayers.add(curWaveLayer);
			}
//			curWaveLayer.scrollFactor = 0.5;
		}
		
		override public function update():void
		{
			//Player movement and controls
			mainPlayer.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				mainPlayer.acceleration.x = -mainPlayer.maxVelocity.x*160;
			if(FlxG.keys.RIGHT)
				mainPlayer.acceleration.x = mainPlayer.maxVelocity.x*160;
			if(FlxG.keys.justPressed("SPACE") && mainPlayer.isTouching(FlxObject.FLOOR))
				mainPlayer.velocity.y = -mainPlayer.maxVelocity.y/2;
			
			//Updates all the objects appropriately
			super.update();

			
			//Finally, bump the player up against the level
			FlxG.collide(tilesLevel,mainPlayer);
			
			//Check for player lose conditions
			if(mainPlayer.y > FlxG.height)
			{
				FlxG.resetState();
			}
		}
		
	}
}
