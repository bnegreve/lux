package{

   import org.flixel.*;

   public class  Player extends FlxSprite{

       private static var XPOS:int = 140;
       private static var FLOOR:int = 300; 
       public var isAlive:Boolean = true;
       
       [Embed(source="../img/playeranime.png")] private var ImgPlayer:Class;

       public function Player(xpos:int, ypos:int){
	   isAlive = true; 
	   super(xpos, ypos);
	   trace("creating player at "+x+", "+y);
	   loadGraphic(ImgPlayer,true,false, 46, 38,false);
	   
	   addAnimation("run",[0,1,2,3,4,5,6,7,8],16);
	   addAnimation("startjump",[9, 10, 11],16,false);
	   addAnimation("jumping",[11],0);
	   addAnimation("endjump",[12,13,14,0],16,false);
	   play("run");
	   maxVelocity.x = 160;
	   maxVelocity.y = 400;
	   acceleration.y = 400;

	   /* hortizontal friction due to his shooes drags him backward*/
	   drag.x = 30;

       }

       override public function update():void{
	   // trace("player dynamic "+y+" "+velocity.y+", "+acceleration.y);
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
	       if(FlxG.keys.UP){
	       	   jump(maxVelocity.y); 
	       }

	       /* horizontal displacements */
	       if(FlxG.keys.RIGHT){
	       	   velocity.x = 140;
	       }
	       if(FlxG.keys.LEFT){
	       	   velocity.x = -140;
	       }
	       if(FlxG.keys.RIGHT && FlxG.keys.LEFT){
	       	   velocity.x = 0;
	       }

	       //its an autorunner after all
	   velocity.x = 400; 
	   checkBoundaries();
       }
   

       protected function isTouchingTheGround():Boolean{
	  return isTouching(DOWN);
//	   return y >= FLOOR;
       }

       protected function checkBoundaries():void{
	   var p:FlxPoint =  getScreenXY();
	   trace("POS X POS Y"+ p.x + " " + p.y + " "+ x +" "+y);
	   if(p.x<3){
	       kill();
	   }
	   
       }

       override public function kill():void{
	       velocity.x = 0; 
	       velocity.y = 0; 
	       isAlive = false;
	       play("jumping");
       }

       protected function jump(jumpVelocity:int):void{
	   /* no horiztontal friction when he flies */
	   drag.x = 0; 
	   acceleration.y = 400;
	   velocity.y = -jumpVelocity*0.6; 
	   play("startjump");
	   trace("jump "+jumpVelocity+" velocity "+velocity.y+" acceleration "+acceleration.y);
       }
       
   }

}
