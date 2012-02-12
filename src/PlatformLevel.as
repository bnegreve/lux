package
{
  import org.flixel.*;
  import com.adobe.serialization.json.*;

  
  public class PlatformLevel extends FlxGroup {

    public var tilesLevel:FlxTilemap;
    public var collideGroup:FlxGroup;
    public var width:Number;
    public var height:Number;

    [Embed(source="../maps/tiles_map.txt", mimeType="application/octet-stream")] private var tilesLevelFile:Class;
    [Embed(source="../maps/struct_maps.txt", mimeType="application/octet-stream")] private var structLevelFile:Class;
    [Embed(source="../maps/struct_props.json",       mimeType="application/octet-stream")] private var PropData:Class;

    [Embed(source="../img/myTiles.png")] private var myTyles:Class;
    [Embed(source="../img/struct_down.png"     )] private var struct_down:Class;
    [Embed(source="../img/struct_straight.png" )] private var struct_straight:Class;
    [Embed(source="../img/struct_up.png"       )] private var struct_up:Class;

    [Embed(source="../img/plateforme_passerelle_1.png"       )] private var plateformePasserelle1:Class;
    private var structProps:Object = {
	"struct_up": { image: struct_up, width: 100, height: 20},
	"struct_down": { image: struct_down, width: 100, height: 20},
	"struct_straight": { image: struct_straight, width: 100, height: 20},
	"plateforme_passerelle_1": { image: plateformePasserelle1, width: 461, height: 29}
      };


    public function PlatformLevel(allLayers:FlxGroup) {

      collideGroup= new FlxGroup();
      tilesLevel = new FlxTilemap();


      loadMainMap(allLayers);
      generateLevel(allLayers)
      width = tilesLevel.width;
    }


    private function loadMainMap(allLayers:FlxGroup):void {
      // First we decode the prop data into an Object.
      var prop_data:Object = com.adobe.serialization.json.JSON.decode(new PropData);

      // The prop data is exported from Flevel as an array of arrays -- one for each layer (even
      // if you only have one layer). Thus, we can get the number of layers by calling
      // prop_data.length. We'll use that to load each layer.
      

      for (var i:uint = 0; i < prop_data.length; i++) {
      	loadStructLayer(prop_data, allLayers, i);
      }

      ////Create a new tilemap using our level data
      //tilesLevel = new FlxTilemap();
      //tilesLevel.loadMap(new levelFile, myTyles ,10,10,0);
      ////level.loadMap(new level_file, FlxTilemap.ImgAuto,0,0,FlxTilemap.AUTO);
      //allLayers.add(tilesLevel);
    }

    private function generateLevel(allLayers:FlxGroup):void {
//	tilesLevel.loadMap(new structLevelFile, myTyles, 10, 10, 0);
//	allLayers.add(tilesLevel);




	var length:int = 20000; 
	FlxG.worldBounds.width = length;

	var nextHeight:int = 200;
	for(var i:int = 0; i < length; ){
	    
	    nextHeight += FlxG.random()*200 - 100;
	    i+= placeLongPlateforme(i, nextHeight);

	    /* generate a random gap */
	    i+= FlxG.random()*300;
	}
	allLayers.add(collideGroup);
    }

    private function placeLongPlateforme(xpos:int, ypos:int):int{
	var data:Object  = structProps["plateforme_passerelle_1"];
	if(ypos >= FlxG.height)
	ypos = FlxG.height - data.height;
	if(ypos < 2*data.height)
	ypos = 2*data.height;
	
	var sprite:FlxSprite = new FlxSprite(xpos, ypos);
	sprite.loadGraphic(data.image, true, false, data.width, data.height, false);
	sprite.immovable = true;
	collideGroup.add(sprite);
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
