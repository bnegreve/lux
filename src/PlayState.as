package
{
	import org.flixel.*;
	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;



	public class PlayState extends FlxState
	{

		private var player:Player;
		private var cameraTarget:FlxSprite;
		
		private var platformLevel:PlatformLevel;
		private var seaLayers:SeaLayers;

		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		private var allLayers:FlxGroup;

		private var globalWidth:Number;
		private var globalHeight:Number;

		private	var cam:FlxCamera; 
		private var lightMask:LightMask;
		private var gameState:int; 
		
		public static  function screenToWorldCoord(screen:FlxPoint):FlxPoint{
		    var worldPoint:FlxPoint = new FlxPoint;
		    worldPoint.x = screen.x + FlxG.camera.scroll.x;
		    worldPoint.y = screen.y + FlxG.camera.scroll.y;
		    return worldPoint;
		}


		override public function create():void
		{

		    gameState=0;/* game is running */
		    allLayers = new FlxGroup();

		    // Differents must eb added in order, from background to foreground

		    platformLevel = new PlatformLevel(allLayers);
		    globalWidth = platformLevel.width;
		    globalHeight = platformLevel.height;
		    trace("globalWidth:"+globalWidth+" globalHeight:"+globalHeight);
		    //Set the background color to light gray (0xAARRGGBB)
		    FlxG.bgColor = 0xff333333;
		    
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
		    
		    
		    cam = FlxG.camera;


		    cameraTarget = new FlxSprite(FlxG.height/2, FlxG.width);
//		    cameraTarget = new FlxSprite(FlxG.width/2, globalHeight - FlxG.height/2);
		    add(cameraTarget);
		    cameraTarget.velocity.x = 275;
		    cam.follow(cameraTarget);
		    cam.setBounds(0, 0, globalWidth, globalHeight);


		    // Display mouse pointer
		    FlxG.mouse.show();

		    // Add the layers to the scene.
		    add(allLayers);



		    // FlxG.camera.setBounds(0, 0, tilesLevel.width, FlxG.height);
		    // FlxG.camera.follow(player);
		    // FlxG.addCamera(FlxG.camera);

		    var worldPos:FlxPoint = screenToWorldCoord(new FlxPoint(100, FlxG.height/2));

		    player = new Player(20, globalHeight - 2*(FlxG.height/3));

		    player.stop();
		    var head:Head = new Head(player);
		    lightMask = new LightMask(head);

		    add(lightMask);
		    add(player);
		    add(head);

//		    worldPos = screenToWorldCoord(new FlxPoint(70, 100));
		    add(new FlxText(30, 100,200,"Click to start"))

		}

		public function start():void{
		    player.run();
		    gameState=1;
		    cameraTarget.velocity.x=player.maxVelocity.x;
		}

		public function reset():void{
		    gameState=0;
		    FlxG.resetState();
		}


		protected function checkBoundaries():void{
		    if(player.x - cam.scroll.x <3 || player.y > FlxG.height){
			player.kill();
			reset();
		    }
		}
       
		override public function update():void
		{

			super.update();
			
			if(gameState == 1){
			    checkBoundaries();
			    
			    FlxG.collide(platformLevel.tilesLevel,player);
			    FlxG.collide(platformLevel.collideGroup,player);

 			    if(FlxG.random()>0.995)
			    lightMask.fireFlash();


			}
			else{
			    if(gameState == 0){
				player.stop();
				cameraTarget.velocity.x=0;
				if(FlxG.mouse.justPressed()){
				    start(); 
				    add(new FlxText(FlxG.width/2+cam.scroll.x+40,205,200,"Click to jump"))
				}
			    }
			}
		    }


		public function gameOver():void{
		    gameState = 0; 
		    cameraTarget.velocity.x = 0;
		    lightMask.lightOn = false;
		    add(new FlxText(FlxG.width/2+cam.scroll.x,FlxG.height/2,400,"Game Over"))
		}


		
	}
}
