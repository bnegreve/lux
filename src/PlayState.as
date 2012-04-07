package
{
	import org.flixel.*;
	import com.adobe.serialization.json.*;
	import flash.display.Sprite;
	import flash.display.*;



	public class PlayState extends FlxState
	{

		private var player:Player;
		private var cameraTarget:FlxObject;
		
		private var platformLevel:PlatformLevel;
		private var seaLayers:SeaLayers;

		// The layers FlxGroup is going to be comprised of one FlxGroup for each layer.
		private var allLayers:FlxGroup;

		private var globalWidth:Number;
		private var globalHeight:Number;

		private	var cam:FlxCamera; 
		private var lightMask:LightMask;
		private var gameState:int; 

		public static var globalCount:int = 0;
		
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

		    // Differents must be added in order, from background to foreground

		    platformLevel = new PlatformLevel(allLayers);
		    globalWidth = platformLevel.width;
		    globalHeight = platformLevel.height;
		    trace("globalWidth:"+globalWidth+" globalHeight:"+globalHeight);
		    FlxG.bgColor = 0xff333333;
		    
		    seaLayers = new SeaLayers(allLayers, globalWidth, globalHeight);
		    FlxG.worldBounds = new FlxRect(0, 0, globalWidth, globalHeight);

		    cam = FlxG.camera;
		    cameraTarget = new FlxObject(FlxG.height/2, FlxG.width);
		    add(cameraTarget);
		    cameraTarget.velocity.x = 275;
		    cam.follow(cameraTarget);
		    cam.setBounds(0, 0, globalWidth, globalHeight);


		    // Display mouse pointer
		    // FlxG.mouse.show();

		    // Add the layers to the scene.
		    add(allLayers);


		    player = new Player(20, PlatformLevel.FIRST_PLATFORM_YPOS-120);
		    player.stop();
		    var head:Head = new Head(player);
		    lightMask = new LightMask(head);

		    add(lightMask);
		    add(player);
		    add(head);

		    add(new FlxText(30,PlatformLevel.FIRST_PLATFORM_YPOS-80,200,"Click to start"))

		}

		public function start():void{
		    player.run();
		    gameState=1;
		    cameraTarget.velocity.x=player.maxVelocity.x;
		    addDrone();
		}

		public function reset():void{
		    gameState=0;
		    FlxG.resetState();
		}

		public function addDrone():void{
		    var drone:Drone = new Drone(
			screenToWorldCoord(new FlxPoint(400, 100)).x,
			screenToWorldCoord(new FlxPoint(100, 100)).y
		    );
		    add(drone); 
		}

		protected function checkBoundaries():void{
		    if(player.x - cam.scroll.x <3 || player.y > globalHeight){
			player.kill();
			reset();
		    }
		}
       
		override public function update():void
		{
		    globalCount+=1;

		    super.update();
		    
		    cameraTarget.y=player.y;

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
				add(new FlxText(380,PlatformLevel.FIRST_PLATFORM_YPOS,200,"Click to jump"))
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
