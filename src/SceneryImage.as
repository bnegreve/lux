package
{
  public class SceneryImage {
    public var image:Class;
    public var scrollFactor:Number;
    public var width:Number;
    public var height:Number;

    public function SceneryImage(_image:Class, _scrollFactor:Number, _width:Number, _height:Number) {
      image        = _image;
      scrollFactor = _scrollFactor;
      width        = _width;
      height       = _height;
    }
  }
}

