package{

   import org.flixel.*;

   public class  Player extends FlxSprite{

       private static var XPOS:int = 140;
       private static var FLOOR:int = 300; 
       [Embed(source="../img/player.png")] private var ImgPlayer:Class;

       public function Player(xpos:int, ypos:int){
	   super(xpos, ypos);
	   trace("creating player at "+x+", "+y);
	   loadGraphic(ImgPlayer,true,false, 106, 154,false);
	   addAnimation("run",[0,1,2,3],12);
	   loadGraphic(ImgPlayer,true,true, 106, 154,false);
	   addAnimation("runBack",[0],6);
	   play("Player");
	   maxVelocity.x = 80;
	   maxVelocity.y = 200;
	   acceleration.y = 200;
	   /* hortizontal friction due to his shooes drags him backward*/
	   drag.x = 30;
       }

       override public function update():void{
	   trace("player dynamic "+y+" "+velocity.y+", "+acceleration.y);

	   if(isTouchingTheGround()){
	       
	       if(velocity.y > 2){
		   /* hit the ground with velocity -> bounce */
	       	       trace("natural bounce value "+0.5*velocity.y);
	       	       jump(0.4 * velocity.y);
	       	   }
		   else if (velocity.y < 0){
		       /* player is bouncing up, do nothing */
		   }
		   else{
		       velocity.y = 0;
		       acceleration.y = 0; 
		       /* reset horizontal friction */
		       drag.x = 30;
		   }
	       
	       /* jump */
	       if(FlxG.keys.UP){
	       	   jump(maxVelocity.y); 
	       }

	       /* horizontal displacements */
	       if(FlxG.keys.RIGHT){
	       	   velocity.x = 50;
		   play("run"); 
	       }
	       if(FlxG.keys.LEFT){
	       	   velocity.x = -50;
		   play("runBack");
	       }
	       if(FlxG.keys.RIGHT && FlxG.keys.LEFT){
	       	   velocity.x = 0;
	       }
	   }
       }
   

       protected function isTouchingTheGround():Boolean{
	   return y >= FLOOR;
       }



       protected function jump(jumpVelocity:int):void{
	   /* no horiztontal friction when he flies */
	   drag.x = 0; 
	   acceleration.y = 200;
	   velocity.y = -jumpVelocity; 
	   trace("jump "+jumpVelocity+" velocity "+velocity.y+" acceleration "+acceleration.y);
       }
       
   }

}
