package
{
    import flash.display.*;
    import flash.external.ExternalInterface;
   import org.flixel.*;

    public class PlayState extends FlxState
    {
    
    private var user:User; 
    private var other:Sea; 
    private var other2:Sea; 

    
	override public function create():void
	{
//	    FlxG.bgColor = 0x33333300;
	    
	    add(new FlxText(0,0,200,"Hello, World!")); //adds a 100x20 text field at position 0,0 (upper left)

	    user = new User(0, 100); 
	    other = new Sea(500, 100);
	    other2 = new Sea(0, 400);
	    trace("poulet\n");

	    add(user);
	    add(other);
	    add(other2);
	}


	public function poulet():void{
	    trace("poulet");

}
 	override public function update():void{
	    super.update();
	    trace(user.velocity.x);
	    trace(user.velocity.y);
	    FlxG.collide(other,user);
	    FlxG.overlap(other2, user, user.repulse);
	    
	}
	
    }
    
    
}