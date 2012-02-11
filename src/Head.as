package{

   import org.flixel.*;

   public class Head extends FlxSprite{
    
       private static var angle:int;
       [Embed(source="../img/head.png")] private var ImgHead:Class;
       private var body:FlxSprite;

       public function Head(body:FlxSprite){
	   super(body.x, body.y-40);
	   this.body = body;
	   loadGraphic(ImgHead, true, false, 100, 100);
	   addAnimation("headHi",[2],0);
	   addAnimation("headMed",[1],0);
	   addAnimation("headLow",[0],0);
	   play("head");
       }


       override public function update():void{
	   x = body.x; 
	   y = body.y -40;
	   var headPos:FlxPoint = new FlxPoint(x, y);

	   var angle:int = FlxU.getAngle(headPos, FlxG.mouse);
	   trace("ANGLE = "+angle); 
	   if(angle < 20)
	       play("headHi"); 
	   else if(angle < 60)
	   play("headMed");
	   else
	   play("headLow");
       }
 
       protected function computeHeadAngle():void{

       }
       
   }
}