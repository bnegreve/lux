package
{
	import org.flixel.*;
//	import com.adobe.serialization.json.*;


	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:FlxSprite;

		[Embed(source="props.json",       mimeType="application/octet-stream")] private var prop_data:Class;

		[Embed(source="tiles_map.txt", mimeType="application/octet-stream")] private var levelFile:Class;
		[Embed(source="waves1_layer.txt", mimeType="application/octet-stream")] private var waves1File:Class;
		[Embed(source="waves2_layer.txt", mimeType="application/octet-stream")] private var waves2File:Class;

		[Embed(source="myTiles.png")] private var myTyles:Class;
		
		override public function create():void
		{
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xffaaaaaa;
			
			//Create a new tilemap using our level data
			level = new FlxTilemap();
			level.loadMap(new levelFile, myTyles ,10,10,0);
			//level.loadMap(new level_file, FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
			add(level);
			
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
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			trace("width: "+level.width);
			trace("heigth: "+level.height);
			
			/* The camera won¿t travel beyond the limits defined
			 * here. Useful so that it won¿t travel to places the
			 * player isn¿t supposed to see (for example beyond the
			 * edge of the level in the demo). */
	
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			
			//Create player (a red box)
			player = new FlxSprite(15, 15);
			player.makeGraphic(10,12,0xffaa1111);
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			player.acceleration.y = 200;
			player.drag.x = player.maxVelocity.x*4;
			add(player);
			
			var cam:FlxCamera = new FlxCamera(0,0, FlxG.width, FlxG.height); // we put the first one in the top left corner
			cam.follow(player);
			// this sets the limits of where the camera goes so that it doesn't show what's outside of the tilemap
			cam.setBounds(0,0,level.width, level.height);
			FlxG.addCamera(cam);

			// Display mouse pointer
			FlxG.mouse.show();


		}
		
		override public function update():void
		{
			//Player movement and controls
			player.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				player.acceleration.x = -player.maxVelocity.x*160;
			if(FlxG.keys.RIGHT)
				player.acceleration.x = player.maxVelocity.x*160;
			if(FlxG.keys.justPressed("SPACE") && player.isTouching(FlxObject.FLOOR))
				player.velocity.y = -player.maxVelocity.y/2;
			
			//Updates all the objects appropriately
			super.update();

			
			//Finally, bump the player up against the level
			FlxG.collide(level,player);
			
			//Check for player lose conditions
			if(player.y > FlxG.height)
			{
				FlxG.resetState();
			}
		}
		
	}
}
