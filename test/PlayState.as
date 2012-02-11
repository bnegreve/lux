package
{
 
   import org.flixel.*;

    public class PlayState extends FlxState
    {
	override public function create():void
	{
	    add(new FlxText(0,0,200,"Hello, World!")); //adds a 100x20 text field at position 0,0 (upper left)
	    add(new Sea(0, 100)); 
	    }
    }

}