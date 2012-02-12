package
{
	import org.flixel.*;
//	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;


	public class PlayState extends FlxState
	{
		private var player:FlxSprite;
		private var tilesLevel:FlxTilemap;
		
		private var wavesLayer1:FlxTilemap;
		private var wavesLayer2:FlxTilemap;

		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		public var allLayers:FlxGroup;

		// This is an Object that stores some information about each of our props. See below for
		// details.
		private var props:Object;		

		private var darkness:FlxSprite;
		private	var cam:FlxCamera; 

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
		    darkness = new FlxSprite(0,0);
		    darkness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
//		    darkness.loadGraphic(ImgLightMask);
		    darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
		    darkness.blend = "multiply";

		    add(darkness);

			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xff222222;
			
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

			player = new Player(100, 100); 
			add(player);

			
			cam = new FlxCamera(0,0, FlxG.width, FlxG.height); // we put the first one in the top left corner
			cam.follow(player);
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
				"waves1": { image: wavesImg1, scrollFactor: 0.5, width: 100, height: 20 },
				"waves2": { image: wavesImg2, scrollFactor: 0.7, width: 100, height: 20 }
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
			FlxG.collide(tilesLevel,player);
			
			//Check for player lose conditions
			if(player.y > FlxG.height)
			{
				FlxG.resetState();
			}
		}
		
	}
}
