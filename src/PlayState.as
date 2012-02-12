package
{
	import org.flixel.*;
//	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;


	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:Player; 
		private var darkness:FlxSprite;
		private	var cam:FlxCamera; 
		[Embed(source="../img/lightmask.png")] private var ImgLightMask:Class;
		[Embed(source="props.json",       mimeType="application/octet-stream")] private var prop_data:Class;

		[Embed(source="tiles_map.txt", mimeType="application/octet-stream")] private var levelFile:Class;
		[Embed(source="waves1_layer.txt", mimeType="application/octet-stream")] private var waves1File:Class;
		[Embed(source="waves2_layer.txt", mimeType="application/octet-stream")] private var waves2File:Class;

		[Embed(source="myTiles.png")] private var myTyles:Class;
		
		override public function create():void
		{
		    darkness = new FlxSprite(0,0);
		    darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
//		    darkness.loadGraphic(ImgLightMask);
		    darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
		    darkness.blend = "multiply";

		    add(darkness);

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
			// player = new FlxSprite(15, 15);
			// player.makeGraphic(10,12,0xffaa1111);
			// player.maxVelocity.x = 80;
			// player.maxVelocity.y = 200;
			// player.acceleration.y = 200;
			// player.drag.x = player.maxVelocity.x*4;

			player = new Player(100, 100); 
			add(player);

			
			cam = new FlxCamera(0,0, FlxG.width, FlxG.height); // we put the first one in the top left corner
			cam.follow(player);
			// this sets the limits of where the camera goes so that it doesn't show what's outside of the tilemap
			cam.setBounds(0,0,level.width, level.height);
			FlxG.addCamera(cam);

			// Display mouse pointer
			FlxG.mouse.show();


		}
		
		public function drawTriangle(Sprite:FlxSprite, Center:FlxPoint, Radius:Number = 30, LineColor:uint = 0xffffffff, LineThickness:uint = 1, FillColor:uint = 0xffffffff):void {
		    
		    var gfx:Graphics = FlxG.flashGfx;
		    gfx.clear();
		    
		    // Line alpha
		    var alphaComponent:Number = Number((LineColor >> 24) & 0xFF) / 255;
		    if(alphaComponent <= 0)
		    alphaComponent = 1;
		    
		    gfx.lineStyle(LineThickness, LineColor, alphaComponent);
		    
		    // Fill alpha
		    alphaComponent = Number((FillColor >> 24) & 0xFF) / 255;
		    if(alphaComponent <= 0)
		    alphaComponent = 1;
		    
		    gfx.beginFill(FillColor & 0x00ffffff, alphaComponent);
		    
		    //	    gfx.drawCircle(Center.x, Center.y, Radius);

		    var star_commands:Vector.<int> = new Vector.<int>(4, true);
		    star_commands[0] = 1;
		    star_commands[1] = 2;
		    star_commands[2] = 2;
		    star_commands[3] = 2;
		    // star_commands[4] = 2;

		    var star_coord:Vector.<Number> = new Vector.<Number>(8, true);
		    star_coord[0] = 0+Center.x; //x
		    star_coord[1] = 100+Center.y; //y
		    star_coord[2] = 200+Center.x;
		    star_coord[3] = 50+Center.y;
		    star_coord[4] = 200+Center.x;
		    star_coord[5] = 150+Center.y;
		    star_coord[6] = 0+Center.x; //x
		    star_coord[7] = 100+Center.y; //y

		    gfx.drawPath(star_commands, star_coord);

		    gfx.endFill();
		    
		    Sprite.pixels.draw(FlxG.flashGfxSprite);
		    Sprite.dirty = true;
		}

		override public function draw():void {
		    darkness.fill(0xff000000);
		    drawTriangle(darkness, new FlxPoint(player.x+60, player.y-100), 100); 
		    
		    super.draw();

		}



		override public function update():void
		{

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
