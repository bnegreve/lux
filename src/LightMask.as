package
{
    import org.flixel.*;
    //	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.Graphics;

    import flash.display.*;
    import flash.geom.*;
    
    
    public class LightMask extends FlxSprite{
	private var player:FlxSprite;
	public var lightOn:Boolean;
	public var flash:int;
	private static const FLASH_DEFAULT_LENGTH:int = 20;
	public function LightMask(player:FlxSprite){
	    this.player = player; 
	    super(0,0);
	    makeGraphic(FlxG.width, FlxG.height, 0xff000000);
	    lightOn = true;
	    flash = 0;
	    scrollFactor.x = scrollFactor.y = 0;
	    blend = "multiply";
	}

	/**
	 * Find the angle of a segment from (x1, y1) -> (x2, y2 )
	 */
	public static function computePlayerLightAngle(p1:FlxPoint, p2: FlxPoint):Number {
	    var angle:Number = Math.atan2( p2.y - p1.y, p2.x - p1.x );
 	    if(angle < -1){angle = -1;}
	    if(angle > 1){angle = 1;}
	  return angle; 
	}

	public function drawLight(Sprite:FlxSprite, origin:FlxPoint,
	    thickness:int, angle:Number, Color:uint=0xffffffff):void{


	    var gfx:Graphics = FlxG.flashGfx;
	    gfx.clear();
	    gfx.lineStyle(0, 0x00000000, 0x00);
	    
	    
	    // Fill alpha
	    var alphaComponent:Number = Number((color >> 24) & 0xFF) / 255;
	    if(alphaComponent <= 0)
	    alphaComponent = 1;
	    
	    gfx.beginFill(color & 0x00ffffff, alphaComponent);

	    var starCommands:Vector.<int> = new Vector.<int>(4, true);
	    starCommands[0] = 1;
	    starCommands[1] = 2;
	    starCommands[2] = 2;
	    starCommands[3] = 2;

	    var translatePoint:Point = Point.polar(FlxG.width + 200, angle);
	    var translatePoint1:Point = Point.polar(120, angle + 1.6);
	    var translatePoint2:Point = Point.polar(120, angle - 1.6);
	    var newTarget:FlxPoint = new FlxPoint();

	    newTarget.copyFrom(origin);
	    newTarget.x += translatePoint.x;
	    newTarget.y += translatePoint.y;
	    var newTarget1:FlxPoint = new FlxPoint();
	    newTarget1.copyFrom(newTarget);
	    newTarget1.x += translatePoint1.x;
	    newTarget1.y += translatePoint1.y;
	    var newTarget2:FlxPoint = new FlxPoint();
	    newTarget2.copyFrom(newTarget);
	    newTarget2.x += translatePoint2.x;
	    newTarget2.y += translatePoint2.y;

	    var starCoord:Vector.<Number> = new Vector.<Number>(8, true);
	    starCoord[0] = 0+origin.x; //x
	    starCoord[1] = origin.y; //y
	    starCoord[2] = newTarget1.x;
	    starCoord[3] = newTarget1.y;
	    starCoord[4] = newTarget2.x;
	    starCoord[5] = newTarget2.y;
	    starCoord[6] = 0+origin.x; //x
	    starCoord[7] = origin.y; //y

	    gfx.drawPath(starCommands, starCoord);

	    gfx.endFill();
	    
	    Sprite.pixels.draw(FlxG.flashGfxSprite);
	    Sprite.dirty = true;
	    
	}

	public function fireFlash():void{
	    flash = FLASH_DEFAULT_LENGTH;
	}
	
	override public function draw():void {

	    //	    trace(" MOUSE X MOUSE Y head X head Y"+FlxG.mouse.x+" "+FlxG.mouse.y+" "+player.x+" "+player.y);
	    fill(0xff000000);


	    if(flash != 0){
		if(flash == FLASH_DEFAULT_LENGTH){
		    /* first flash frame : blind the screen */
		    blend = "add";
		    fill(0xffff8888);

		}
		else{
		    var flashColor:int = 0x0;
		    blend = "multiply";
		    //		    sets  alpha component
		    flashColor=((((FLASH_DEFAULT_LENGTH-flash))/FLASH_DEFAULT_LENGTH)*256.0)<<24;	    	    fill(flashColor);
		}
		flash--;
	    }

	    /* draw the light*/
	    if(lightOn){
		var playerLightOrigin:FlxPoint = new FlxPoint(player.x+20-FlxG.camera.scroll.x,
			player.y - FlxG.camera.scroll.y);  

		var playerLightAngle:Number = computePlayerLightAngle(playerLightOrigin, 
		    new FlxPoint(FlxG.mouse.x - FlxG.camera.scroll.x, FlxG.mouse.y - FlxG.camera.scroll.y));

		drawLight(this, playerLightOrigin, 0, playerLightAngle, 0);
	    }
	    else
	    fill(0xbb000000);

	    super.draw();

	}

    }

}
