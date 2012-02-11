package {
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="1680", height="900", backgroundColor="#222222")] //Set the size and color of the Flash file
 
	public class HelloWorld extends FlxGame
	{
		public function HelloWorld()
		{
			super(940,560,PlayState,1); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}
 