package
{
  import org.flixel.*;
  import com.adobe.serialization.json.*;

  
  public class PlatformLevel extends FlxGroup {

    public var tilesLevel:FlxTilemap;
    public var collideGroup:FlxGroup;
    public var backgroundGroup:FlxGroup;
    public var backgroundGroup2:FlxGroup;
    public var width:Number;
    public var height:Number;
    public static const LEVEL_LENGTH:int = 10000; 
    public static const LEVEL_HEIGHT:int = 700;
    public static const JUMP_MAX_HEIGHT:int = 200; 
    public static const PLATFORM_MAX_HEIGHT:int = 46; 
    public static const FIRST_PLATFORM_YPOS:int = 400; 

    [Embed(source="../maps/tiles_map.txt", mimeType="application/octet-stream")] private var tilesLevelFile:Class;
    [Embed(source="../maps/struct_maps.txt", mimeType="application/octet-stream")] private var structLevelFile:Class;
    [Embed(source="../maps/struct_props.json",       mimeType="application/octet-stream")] private var PropData:Class;

    [Embed(source="../img/myTiles.png")] private var myTyles:Class;
    [Embed(source="../img/struct_down.png"     )] private var struct_down:Class;
    [Embed(source="../img/struct_straight.png" )] private var struct_straight:Class;
    [Embed(source="../img/struct_up.png"       )] private var struct_up:Class;

    [Embed(source="../img/platform_simple_long.png"       )] private var platformSimpleLong:Class;
    [Embed(source="../img/platform_cabin_base.png"       )] private var platformCabinBase:Class;
    [Embed(source="../img/platform_cabin_1.png"       )] private var platformCabin:Class;
    [Embed(source="../img/base_1.png"       )] private var base1:Class;
    //    [Embed(source="../img/plateforme_caisse_1.png"       )] private var caisse:Class;
    [Embed(source="../img/boat.png"       )] private var boat:Class;
    [Embed(source="../img/arr_1.png"       )] private var arr1:Class;
    [Embed(source="../img/arr_2.png"       )] private var arr2:Class;
    [Embed(source="../img/arr_3.png"       )] private var arr3:Class;
    [Embed(source="../img/arr_4.png"       )] private var arr4:Class;
    [Embed(source="../img/arr_5.png"       )] private var arr5:Class;
    [Embed(source="../img/arr_6.png"       )] private var arr6:Class;
    [Embed(source="../img/platform3_start.png"       )] private var platform3Start:Class;
    [Embed(source="../img/platform3_center.png"       )] private var platform3Center:Class;
    [Embed(source="../img/platform3_end.png"       )] private var platform3End:Class;
    private var structProps:Object = {
	"struct_up": { image: struct_up, width: 100, height: 20},
	"struct_down": { image: struct_down, width: 100, height: 20},
	"struct_straight": { image: struct_straight, width: 100, height: 20},
	"platformSimpleLong": { image: platformSimpleLong, width: 461, height: 29},
	"platformCabinBase": { image: platformCabinBase, width: 200, height: 46},
	"platformeCabin": { image: platformCabin, width: 80, height: 46},
	"base1": { image: base1, width: 170, height: 16}, 
//	"caisse": { image: caisse, width: 16, height: 16},
	"boat": { image: boat, width: 1024, height: 624},
	"arr1": { image: arr1, width: 428, height: 221},
	"arr2": { image: arr2, width: 301, height: 424},
	"arr3": { image: arr3, width: 974, height: 502},
	"arr4": { image: arr4, width: 461, height: 120},
	"arr5": { image: arr5, width: 755, height: 322},
	"arr6": { image: arr6, width: 628, height: 323},
	"platform3Start": { image: platform3Start, width: 86, height: 44},
	"platform3Center": { image: platform3Center, width: 56, height: 44},
	"platform3End": { image: platform3End, width: 86, height: 44}
      };


    public function PlatformLevel(allLayers:FlxGroup) {

      collideGroup= new FlxGroup();
      backgroundGroup= new FlxGroup();
      backgroundGroup2= new FlxGroup();
      tilesLevel = new FlxTilemap();


      loadMainMap(allLayers);
      generateLevel(allLayers)
      width = LEVEL_LENGTH; //tilesLevel.width;
      height = LEVEL_HEIGHT; 
    }


    private function loadMainMap(allLayers:FlxGroup):void {
      // First we decode the prop data into an Object.
      var prop_data:Object = com.adobe.serialization.json.JSON.decode(new PropData);

      // The prop data is exported from Flevel as an array of arrays -- one for each layer (even
      // if you only have one layer). Thus, we can get the number of layers by calling
      // prop_data.length. We'll use that to load each layer.
      

      // for (var i:uint = 0; i < prop_data.length; i++) {
      // 	loadStructLayer(prop_data, allLayers, i);
      // }

      ////Create a new tilemap using our level data
      //tilesLevel = new FlxTilemap();
      //tilesLevel.loadMap(new levelFile, myTyles ,10,10,0);
      ////level.loadMap(new level_file, FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
      //allLayers.add(tilesLevel);
    }

    private function generateLevel(allLayers:FlxGroup):void {

	var length:int = LEVEL_LENGTH;
	var nextYPos:int = FIRST_PLATFORM_YPOS; // Vertical post of the first platform.
	var i:int = 0
	

	/* Place  the first platform */
	i+= placePlatformSimpleLong(i, nextYPos);
	    
	/* Then the others .. */ 
	while(i < length){

	    /* Generate a random gap. */
	    i+= FlxG.random()*300;
	    
	    /* Compute the next platform vertical position. */
	    var vOffset:int = FlxG.random()*200 - 100;
	    nextYPos += vOffset;
	    vOffset = Math.max(nextYPos,
		FlxG.height/2 // The camera must not hit the top border of the world ..
		+ JUMP_MAX_HEIGHT  // .. even if player jumps ..
		+ PLATFORM_MAX_HEIGHT); // .. from the highest platform.
	    nextYPos = Math.min(nextYPos, LEVEL_HEIGHT-200);
	    
	    /* Put the platform. */
	    if(FlxG.random()<0.35)
	    i+= placePlatformSimpleLong(i, nextYPos);
	    else if(FlxG.random()<0.65){
	    	var numElements:int = FlxG.random()*10+5;
	    	i+= placePlatform3(i, nextYPos, numElements);
	    }
	    else
	    i+= placePlatformeCabin(i, nextYPos);
	}
	
	/* Add background2 decorations */
	var boatPos:int = FlxG.random()* length ;
	placeBoat(boatPos, 200); 

	var pos:int = FlxG.random()* length ;
	placeBackground2Object(pos, 200,"arr1"); 

	pos = FlxG.random()* length ;
	placeBackground2Object(pos, 200, "arr2");


	pos = FlxG.random()* length ;
	placeBackground2Object(pos, 200, "arr3");


	pos = FlxG.random()* length ;
	placeBackground2Object(pos, 200, "arr4");


	pos = FlxG.random()* length ;
	placeBackground2Object(pos, 200, "arr5");


	pos = FlxG.random()* length ;
	placeBackground2Object(pos, 200, "arr6");


	allLayers.add(backgroundGroup2);
	allLayers.add(backgroundGroup);
	allLayers.add(collideGroup);
    }

    private function placeBoat(xpos:int, ypos:int):void{
	var data:Object  = structProps["boat"];
	if(xpos+data.width > LEVEL_LENGTH){
	    xpos -= data.width; 
	}
	var sprite:FlxSprite = new FlxSprite(xpos, ypos);
	sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	sprite.immovable = true;
	backgroundGroup.add(sprite);
    }


    private function placeBackground2Object(xpos:int, ypos:int, objectType:String):void{
	var data:Object  = structProps[objectType];
	if(xpos+data.width > LEVEL_LENGTH){
	    xpos -= data.width; 
	}
	var sprite:FlxSprite = new FlxSprite(xpos, ypos);
	sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	sprite.immovable = true;
	backgroundGroup2.add(sprite);
    }

    private function placePlatformSimpleLong(xpos:int, ypos:int):int{
	var data:Object  = structProps["platformSimpleLong"];
	 if(ypos >= LEVEL_HEIGHT)
	 ypos = LEVEL_HEIGHT - data.height;

	
	var sprite:FlxSprite = new FlxSprite(xpos, ypos);
	sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	sprite.immovable = true;
	collideGroup.add(sprite);
	return data.width;
    }


    private function placePlatform3(xpos:int, ypos:int, numElements:int):int{
	var xOffset:int = xpos; 

	var data:Object  = structProps["platform3Start"];
	if(ypos >= LEVEL_HEIGHT)
	ypos = LEVEL_HEIGHT - data.height;
	var sprite:FlxSprite = new FlxSprite(xOffset, ypos);
	sprite.loadGraphic(data.image, true, false,
	    data.width, data.height);
	sprite.immovable = true;
	collideGroup.add(sprite);
	
	xOffset += data.width;

	data = structProps["platform3Center"];
	for(var i:int = 0; i < numElements; i++){
	    sprite = new FlxSprite(xOffset, ypos);
	    sprite.loadGraphic(data.image, true, false,
		data.width, data.height);
	    xOffset+=data.width;
	    sprite.immovable = true;
	    collideGroup.add(sprite);
	}

	data  = structProps["platform3End"];
	sprite = new FlxSprite(xOffset, ypos);
	sprite.loadGraphic(data.image, true, false,
	    data.width, data.height);
	sprite.immovable = true;
	collideGroup.add(sprite);
	xOffset+=data.width;
	
	return xOffset - xpos;
    }

    private function placePlatformeCabin(xpos:int, ypos:int):int{
	
	var data:Object  = structProps["platformCabinBase"];
	 if(ypos >= LEVEL_HEIGHT)
	 ypos = LEVEL_HEIGHT - data.height;

	var sprite:FlxSprite = new FlxSprite(xpos, ypos);
	sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	sprite.immovable = true;
	collideGroup.add(sprite);

	// if(FlxG.random()>0.5){
	//     /* draw a case */
	//     data  = structProps["caisse"];
	//     sprite = new FlxSprite(xpos+10, ypos-18);
	//     sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	//     sprite.immovable = false;
	//     collideGroup.add(sprite);
	// }

	data  = structProps["platformeCabin"];
	sprite = new FlxSprite(xpos+data.width+10, ypos-40);
	sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	sprite.immovable = true;
	collideGroup.add(sprite);
	
	data  = structProps["base1"];
	for(var i:int = ypos+40; i < LEVEL_HEIGHT; ){
	    sprite = new FlxSprite(xpos+10, i);
	    sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	    sprite.immovable = true;
	    backgroundGroup.add(sprite);
	    i += data.height;
	}



	return data.width;

    }

    private function loadStructLayer(prop_data:Object, allLayers:FlxGroup, index:uint):void {


      // We load an empty map, to set the level to the good dimensions
      tilesLevel.loadMap(new structLevelFile, myTyles, 10, 10, 0);
      allLayers.add(tilesLevel);


      /* Jerome's */
      // Here we loop through all of the props so we can load them.
      // for each (var prop:Object in prop_data[index]) {
      // 	// Now we can load the sprite and do whatever we want with it. This is where all
      // 	// the data we stored at the beginning is useful.
      // 	var data:Object      = structProps[prop.id];
      // 	var sprite:FlxSprite = new FlxSprite(prop.x, prop.y);
      // 	sprite.loadGraphic(data.image, true, false, 100, 20, false);

      // 	// Set the sprite properties from the flevel data.
      // 	sprite.angle   = prop.angle;
      // 	sprite.scale.x = sprite.scale.y = prop.scale;
      // 	sprite.immovable = true;
      // 	sprite.solid = true;
      // 	//sprite.allowCollisions = FlxObject.FLOOR;

      // 	trace("sprite x:"+sprite.x+" y:"+sprite.y+" w:"+sprite.width+" h:"+sprite.height);
      // 	// Add the prop to the layer group.
      // 	collideGroup.add(sprite);
      // }

      // Add the layer to the layers group.
      allLayers.add(collideGroup);
    }



  }
}
