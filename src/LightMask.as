package
{
    import org.flixel.*;
    //	import com.adobe.serialization.json.*;
    import flash.display.Sprite;
    import flash.display.*;

    
    public class LightMask extends FlxSprite{
	private var player:FlxSprite;
	public function LightMask(player:FlxSprite){
	    this.player = player; 
	    super(0,0);
	    makeGraphic(FlxG.width, FlxG.height, 0xff000000);
	    
	    scrollFactor.x = scrollFactor.y = 0;
	    blend = "multiply";
	}


	public function drawTriangle(Sprite:FlxSprite, Center:FlxPoint, target:FlxPoint, Radius:Number = 30, LineColor:uint = 0xffffffff, LineThickness:uint = 1, FillColor:uint = 0xffffffff):void {
	    
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
	    
	    //	    gfx.drawCircle(Center.x, Center.y, Radius);

	    var star_commands:Vector.<int> = new Vector.<int>(4, true);
	    star_commands[0] = 1;
	    star_commands[1] = 2;
	    star_commands[2] = 2;
	    star_commands[3] = 2;
	    // star_commands[4] = 2;

	    var star_coord:Vector.<Number> = new Vector.<Number>(8, true);
	    star_coord[0] = 0+Center.x; //x
	    star_coord[1] = 100+Center.y; //y
	    star_coord[2] = FlxG.width;
	    star_coord[3] = target.y-50;
	    star_coord[4] = FlxG.width;
	    star_coord[5] = target.y+50;
	    star_coord[6] = 0+Center.x; //x
	    star_coord[7] = 100+Center.y; //y

	    gfx.drawPath(star_commands, star_coord);

	    gfx.endFill();
	    
	    Sprite.pixels.draw(FlxG.flashGfxSprite);
	    Sprite.dirty = true;
	}

	override public function draw():void {
	    fill(0x99000000);
	    
	    drawTriangle(this, new FlxPoint(player.x+20-FlxG.camera.scroll.x , player.y-100),FlxG.mouse, 100);
	    
	    super.draw();

	}


    }

}