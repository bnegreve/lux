package
 {
   import org.flixel.*;	
    public class User extends Sea
    {
	[Embed(source="a3.png")] private var ImgSea0:Class;	//The graphic of the squid monster

	private var value : int; 

	override public function User(x:int, y:int){
	    super(x,y);
	    loadGraphic(ImgSea0, true);
 	    addAnimation("Default",[0,1,0,2],6+FlxG.random()*4);
	    
	    //Now that the animation is set up, it's very easy to play it back!
	    play("Default");

	    
	}
	override public function update():void{
			if(FlxG.keys.LEFT)
				velocity.x -= 50;		//If the player is pressing left, set velocity to left 150
			if(FlxG.keys.RIGHT)	
				velocity.x += 50;		//If the player is pressing right, then right 150

			if(FlxG.keys.DOWN)
				velocity.y += 50;		//If the player is pressing left, set velocity to left 150
			if(FlxG.keys.UP)	
				velocity.y -= 50;		//If the player is pressing right, then right 150


	}
	

	public function repulse(User:FlxSprite,User:FlxSprite):void{
	    velocity.x = 0; 
	    velocity.y = 0;
	}

    }
}
