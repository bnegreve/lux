package
{
	import org.flixel.*;
	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;


	public class PlayState extends FlxState
	{
		private var player:FlxSprite;
		private var tilesLevel:FlxTilemap;
		
		private var wavesLayer1:FlxTilemap;
		private var wavesLayer2:FlxTilemap;

		public var structLayer:FlxGroup;
		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		public var allLayers:FlxGroup;

		private var darkness:FlxSprite;
		private	var cam:FlxCamera; 

		[Embed(source="../maps/tiles_map.txt", mimeType="application/octet-stream")] private var tilesLevelFile:Class;
		[Embed(source="../maps/struct_maps.txt", mimeType="application/octet-stream")] private var structLevelFile:Class;

		[Embed(source="../maps/struct_props.json",       mimeType="application/octet-stream")] private var PropData:Class;

		[Embed(source="../img/myTiles.png")] private var myTyles:Class;
		[Embed(source="../img/mer_1.png" )] private var wavesImg1:Class;
		[Embed(source="../img/mer_2.png" )] private var wavesImg2:Class;
		
		[Embed(source="../img/struct_down.png"     )] private var struct_down:Class;
		[Embed(source="../img/struct_straight.png" )] private var struct_straight:Class;
		[Embed(source="../img/struct_up.png"       )] private var struct_up:Class;


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
			FlxG.bgColor = 0xff444444;
			
			var structProps:Object = {
				"struct_up": { image: struct_up, width: 100, height: 20},
				"struct_down": { image: struct_down, width: 100, height: 20},
				"struct_straight": { image: struct_straight, width: 100, height: 20}
			};

			loadMainMap(structProps);
			var wavesProps:Array = new Array (
				new SceneryImage(wavesImg2, 0.7, 1716, 100), 
				new SceneryImage(wavesImg1, 0.5, 1426, 50)
				);

			loadWaves(wavesProps, tilesLevel.width, tilesLevel.height);

			
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

		private function loadMainMap(structProps:Object):void {
			// First we decode the prop data into an Object.
			var prop_data:Object = com.adobe.serialization.json.JSON.decode(new PropData);

			// The prop data is exported from Flevel as an array of arrays -- one for each layer (even
			// if you only have one layer). Thus, we can get the number of layers by calling
			// prop_data.length. We'll use that to load each layer.
			for (var i:uint = 0; i < prop_data.length; i++) {
				loadStructLayer(prop_data, structProps, i);
			}

			////Create a new tilemap using our level data
			//tilesLevel = new FlxTilemap();
			//tilesLevel.loadMap(new levelFile, myTyles ,10,10,0);
			////level.loadMap(new level_file, FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
			//allLayers.add(tilesLevel);
		}

		private function loadStructLayer(prop_data:Object, structProps:Object, index:uint):void {

			structLayer= new FlxGroup();
			
			// Loading the layer's tilemap is easy. Just don't forget to set startingIndex to 1!
			tilesLevel = new FlxTilemap();
//			map.startingIndex = 1;
			tilesLevel.loadMap(new structLevelFile, myTyles, 10, 10, 0);
			structLayer.add(tilesLevel);
			
			// Here we loop through all of the props so we can load them.
			for each (var prop:Object in prop_data[index]) {
				// Now we can load the sprite and do whatever we want with it. This is where all
				// the data we stored at the beginning is useful.
				var data:Object      = structProps[prop.id];
				var sprite:FlxSprite = new FlxSprite(prop.x, prop.y);
				sprite.loadGraphic(data.image, true, false, 100, 20, false);
				
				// Set the sprite properties from the flevel data.
				sprite.angle   = prop.angle;
				sprite.scale.x = sprite.scale.y = prop.scale;
				sprite.immovable = true;
				//sprite.solid = true;
				//sprite.allowCollisions = FlxObject.FLOOR;

				// Add the prop to the layer group.
				structLayer.add(sprite);
			}
			
			// Add the layer to the layers group.
			allLayers.add(structLayer);
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

			// Flixel's collision detection is great, but for
			// large-area games (platformers, etc.) it's
			// impractical to hit test the whole area of the game
			// in every frame. Here is how to check for collisions
			// in ONLY the area of the screen that is currently in
			// the game's view. 
			// FlxU.setWorldBounds(-(FlxG.scroll.x), -(FlxG.scroll.y), FlxG.width, FlxG.height);
			
			//Finally, bump the player up against the level
			FlxG.collide(tilesLevel,player);
			FlxG.collide(structLayer,player);
			
			//Check for player lose conditions
			if(player.y > FlxG.height)
			{
				FlxG.resetState();
			}
		}
		
	}
}
