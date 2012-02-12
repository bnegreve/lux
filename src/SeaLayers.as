package {
  import org.flixel.*;
  import com.adobe.serialization.json.*;


  public class SeaLayers extends FlxGroup {

    private var nbLayers:Number;
    // Lazy class
    // Each cell has the form
    // { dir_hrz, next_change_hrz_cntr, dir_vrt, next_change_vrt_cntr }
    private var layersHistory:Array;

    private var wavesLayer1:FlxTilemap;
    private var wavesLayer2:FlxTilemap;

    [Embed(source="../img/mer_1.png")] private var wavesImg1:Class;
    [Embed(source="../img/mer_2.png")] private var wavesImg2:Class;

    private var wavesProps:Array = new Array (
	  new SceneryImage(wavesImg2, 0.7, 1716, 200), 
	  new SceneryImage(wavesImg1, 0.5, 1426, 100)
	  );

    public function SeaLayers(allLayers:FlxGroup, globalWidth:uint, globalHeight:uint) {
      nbLayers = wavesProps.length;
      layersHistory = new Array(nbLayers);
      for ( var i:int = 0; i < nbLayers; i++ ) {
	layersHistory[i] = [1, 0, 1, 0];
      }
      loadWaves(allLayers, globalWidth, globalHeight);
    }

    private function loadWaves(allLayers:FlxGroup, globalWidth:uint, globalHeight:uint):void {
      var nbRepeat:uint;

      // Now we can load the sprite and do whatever we want with it. This is where all
      // the data we stored at the beginning is useful.

      for (var imgId:uint = 0; imgId < nbLayers; imgId++) {
	var curImg:SceneryImage = wavesProps[imgId];
	var curWaveLayer:FlxGroup = new FlxGroup();

	for (nbRepeat = 0; nbRepeat < globalWidth / curImg.width * 2; nbRepeat++) {
	  var sprite:FlxSprite = new FlxSprite(nbRepeat * curImg.width, globalHeight - curImg.height);
	  sprite.loadGraphic(curImg.image);
	  sprite.scrollFactor.x = curImg.scrollFactor;
	  sprite.solid = false;
	  trace("wave sprite x:"+sprite.x+" y:"+sprite.y+" w:"+sprite.width+" h:"+sprite.height);
	  curWaveLayer.add(sprite);
	}
	this.add(curWaveLayer);
      }
      allLayers.add(this);
    }

    override public function update():void {
      //Updates all the objects appropriately
      super.update();

      //      for (var imgId:uint = 0; imgId < nbLayers; imgId++) {
      //	// if counter == 0, reset counter to random value
      //	if ( layersHistory[1] == 0 ) {
      //	  layersHistory[1] = Math.random()*100;
      //	  layersHistory[0] = layersHistory[0]*-1;
      //	}
      //	trace("======================= poulet: "+this.members[0].members+" =====================================");
      //	for (var j:int = 0; j < this.members[imgId].members.length; j++) {
      //	  trace("------------------------- inf or each -----------------------------");
      //	  var curSprite:FlxSprite = this.members[imgId].members[j];
      //	  curSprite.x += layersHistory[0];
      //	}
      //	layersHistory[1]--;
      //      }
      //    }    
    }
  }
}
