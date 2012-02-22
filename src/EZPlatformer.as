package
{
	import org.flixel.*;
	[SWF(width="1024", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class EZPlatformer extends FlxGame
	{
		public function EZPlatformer()
		{
			super(1024,480,PlayState,1);
			forceDebugger = true;
		}
	}
}
