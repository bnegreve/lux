package
{
    import org.flixel.*;
    //	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;
    
    
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


	public function drawTriangle(Sprite:FlxSprite, start:FlxPoint, target:FlxPoint, LineColor:uint = 0xffffffff, LineThickness:uint = 0, FillColor:uint = 0xffffffff):void {
	    
	    var gfx:Graphics = FlxG.flashGfx;
	    gfx.clear();
	    
	    // Line alpha
	    var alphaComponent:Number = Number((LineColor >> 24) & 0xFF) / 255;
	    if(alphaComponent <= 0)
	    alphaComponent = 1;
	    
	    gfx.lineStyle(LineThickness, LineColor, alphaComponent);
	    
	    // Fill alpha
	    alphaComponent = Number((FillColor >> 24) & 0xFF) / 255;
	    if(alphaComponent <= 0)
	    alphaComponent = 1;
	    
	    gfx.beginFill(FillColor & 0x00ffffff, alphaComponent);
	    
	    //	    gfx.drawCircle(start.x, start.y, Radius);

	    var star_commands:Vector.<int> = new Vector.<int>(4, true);
	    star_commands[0] = 1;
	    star_commands[1] = 2;
	    star_commands[2] = 2;
	    star_commands[3] = 2;
	    // star_commands[4] = 2;

	    var star_coord:Vector.<Number> = new Vector.<Number>(8, true);
	    star_coord[0] = 0+start.x; //x
	    star_coord[1] = start.y; //y
	    star_coord[2] = FlxG.width;
	    star_coord[3] = target.y-100;
	    star_coord[4] = FlxG.width;
	    star_coord[5] = target.y+100;
	    star_coord[6] = 0+start.x; //x
	    star_coord[7] = start.y; //y

	    gfx.drawPath(star_commands, star_coord);

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
		drawTriangle(this, new FlxPoint(player.x+20-FlxG.camera.scroll.x , player.y-FlxG.camera.scroll.y), FlxG.mouse);
	    }
	    else
	    fill(0xbb000000);

	    super.draw();

	}

    }

}