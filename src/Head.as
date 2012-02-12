package{

   import org.flixel.*;

   public class Head extends FlxSprite{
    
       private static var angle:int;
       [Embed(source="../img/head.png")] private var ImgHead:Class;
       private var body:FlxSprite;

       public function Head(body:FlxSprite){
	   super(body.x, body.y-40);
	   this.body = body;
	   loadGraphic(ImgHead, true, false, 12, 8);
	   addAnimation("h1",[7],0);
	   addAnimation("h2",[6],0);
	   addAnimation("h3",[5],0);
	   addAnimation("h4",[4],0);
	   addAnimation("h5",[3],0);
	   addAnimation("h6",[2],0);
	   addAnimation("h7",[1],0);
	   addAnimation("h8",[0],0);

       }


       override public function update():void{
	   x = body.x+20; 
	   y = body.y -10;
	   var headPos:FlxPoint = new FlxPoint(x, y);

	   var angle:int = FlxU.getAngle(headPos, FlxG.mouse);
	   trace("ANGLE = "+angle); 
	   if(angle < 37)
	   play("h1"); 
	   else if(angle < 52)
	   play("h2");
	   else if(angle < 67)
	   play("h3");
	   else if(angle < 82)
	   play("h4"); 
	   else if(angle < 97)
	   play("h5"); 
	   else if(angle < 112)
	   play("h6");
	   else if(angle < 127)
	   play("h7");
	   else 
	   play("h8");
       }
   }
}