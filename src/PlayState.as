package
{
	import org.flixel.*;
	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;


	public class PlayState extends FlxState
	{
		private var player:FlxSprite;
		
		private var platformLevel:PlatformLevel;
		private var seaLayers:SeaLayers;

		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		private var allLayers:FlxGroup;

		private var globalWidth:Number;
		private var globalHeight:Number;

		private	var cam:FlxCamera; 
		private var lightMask:LightMask;

 
		


		override public function create():void
		{

			allLayers = new FlxGroup();		 



			// Differents must eb added in order, from background to foreground

			platformLevel = new PlatformLevel(allLayers);
			globalWidth = platformLevel.width;
			globalHeight = FlxG.height;
			trace("globalWidth:"+globalWidth+" globalHeight:"+globalHeight);
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xff111111;
			
			seaLayers = new SeaLayers(allLayers, globalWidth, globalHeight);
			
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
