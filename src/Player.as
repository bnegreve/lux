package{

   import org.flixel.*;

   public class  Player extends FlxSprite{

       private static var XPOS:int = 140;
       private static var FLOOR:int = 300; 
       public var isAlive:Boolean = true;
       public var maxJump:int;
       public var nbJump:int;
       public var timeCount:int;
       private var running:Boolean; 
       [Embed(source="../img/playeranime.png")] private var ImgPlayer:Class;

       public function Player(xpos:int, ypos:int){
	   isAlive = true;
	   maxJump = 2;
	   nbJump = maxJump - 1; 

	   timeCount= FlxG.elapsed;
	   super(xpos, ypos);
	   trace("creating player at "+x+", "+y);
	   loadGraphic(ImgPlayer,true,false, 46, 38,false);
	   
	   addAnimation("run",[0,1,2,3,4,5,6,7,8],24);
	   addAnimation("startjump",[9, 10, 11],16,false);
	   addAnimation("jumping",[11],0);
	   addAnimation("endjump",[12,13,14,0],16,false);
	   addAnimation("dies",[0],16, false); 
	   play("run");
	   maxVelocity.x = 460;
	   maxVelocity.y = 800;
	   acceleration.y = 8000;
	   acceleration.x = 0;
	   drag.x = 0;
	   running = false; 

       }

       public function run():void{
	   acceleration.y = 400;
	   running = true;
	   play("run");
       }

       public function stop():void{
	   running = false; 
	   velocity.x = 0;
	   velocity.y = 0;
	   acceleration.y = 0;
	   play("dies");
       }

       override public function update():void{
	   
       	   if(running){
       	       //its an autorunner after all
	       velocity.x = maxVelocity.x;
	   }else{
       	       velocity.x = 0;
	   }
	   
	   trace("player dynamic "+y+" "+velocity.x+", "+acceleration.x);
	   // drag.x = 30;
	   
	   // if(FlxG.keys.UP){
	   //     jump(maxVelocity.y);
	   // }

	   // if(FlxG.keys.LEFT){
	   //     velocity.x = -140;
	   // }
	   // if(FlxG.keys.RIGHT){
	   //     velocity.x = 140;
	   // }
	   
	   

	   if(isTouchingTheGround()){
	       trace("TOUCHING");
	       nbJump = maxJump;
	       play("run");
	       // if(velocity.y > 2){
	       // 	   /* hit the ground with velocity -> bounce */
	       // 	       trace("natural bounce value "+0.5*velocity.y);
	       // 	       jump(0.4 * velocity.y);
	       // 	   }
	       // 	   else if (velocity.y < 0){
	       // 	       /* player is bouncing up, do nothing */
	       // 	   }
	       // 	   else{
	       // 	       play("run");
	       // 	       velocity.y = 0;
	       // 	       acceleration.y = 0;
	       // 	       /* reset horizontal friction */
	       // 	       drag.x = 30;
	       // 	   }
	   }

	   /* jump */
	   if(running ==true && FlxG.mouse.justPressed()){
	       jump(400);
	   }

	   // /* horizontal displacements */
	   // if(FlxG.keys.RIGHT){
	   // 	   velocity.x = 140;
	   // }
	   // if(FlxG.keys.LEFT){
	   // 	   velocity.x = -140;
	   // }
	   // if(FlxG.keys.RIGHT && FlxG.keys.LEFT){
	   // 	   velocity.x = 0;
	   // }


       }
       

       protected function isTouchingTheGround():Boolean{
	  return isTouching(DOWN);
//	   return y >= FLOOR;
       }

       override public function kill():void{
	   stop();
	   isAlive=false;
	   play("dies");
       }

       protected function jump(jumpVelocity:int):void{
	   /* no horiztontal friction when he flies */
	   if(nbJump-- > 0){
	       drag.x = 0;
	       acceleration.y = 400;
	       velocity.y = -jumpVelocity*0.6;
	       play("startjump");
	       trace("jump "+nbJump+" "+jumpVelocity+" velocity "+velocity.y+" acceleration "+acceleration.y);
	   }
       }
       
   }

}
