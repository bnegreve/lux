package
 {
   import org.flixel.*;	
    public class Sea extends FlxSprite
    {
	[Embed(source="../img/a3.png")] private var ImgSea0:Class;	//The graphic of the squid monster

	private var value : int; 

	override public function Sea(x:int, y:int){
	    super(x,y);
	    loadGraphic(ImgSea0, true); 
	    addAnimation("Default",[0,1,0,2],6+FlxG.random()*4);
	    
	    //Now that the animation is set up, it's very easy to play it back!
	    play("Default");

	    
	}
	override public function update():void{

	    if(FlxG.keys.justPressed("SPACE")){
		x++;
	    }
	}
    }
}
