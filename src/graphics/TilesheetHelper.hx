package graphics;

import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.Assets;

class TilesheetHelper {
  public static function generateTilesheet(imageName:String, tilesX:Int, tilesY:Int, ?flippedX:Bool = false, ?flippedY:Bool = false):Tilesheet {
    var tempData = Assets.getBitmapData("assets/" + imageName);
    var data = new BitmapData(tempData.width, tempData.height, true);
    data.copyPixels(tempData, new Rectangle(0, 0, tempData.width, tempData.height), new Point(0, 0), null, null, true);

    ImageOpts.keyBitmapData(data);

    if (flippedX || flippedY) {
      data = ImageOpts.flipImageData(data, flippedX, flippedY);
    }

    var tilesheet = new Tilesheet(data);

    var tileWidth = Std.int(data.width / tilesX);
    var tileHeight = Std.int(data.height / tilesY);

    var xTransform = flippedX ? function(x){return (tilesX - x - 1) * tileWidth;} : function(x){return x * tileWidth;};
    var yTransform = flippedY ? function(y){return (tilesY - y - 1) * tileHeight;} : function(y){return y * tileHeight;};
    for (y in 0...tilesY) {
      for (x in 0...tilesX) {
        tilesheet.addTileRect(new Rectangle(xTransform(x), yTransform(y), tileWidth, tileHeight));
      }
    }

    return tilesheet;
  }
}
