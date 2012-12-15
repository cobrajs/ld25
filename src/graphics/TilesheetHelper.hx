package graphics;

import nme.display.Tilesheet;
import nme.geom.Rectangle;
import nme.Assets;

class TilesheetHelper {
  public static function generateTilesheet(imageName:String, tilesX:Int, tilesY:Int):Tilesheet {
    var data = Assets.getBitmapData("assets/" + imageName);
    var tilesheet = new Tilesheet(data);

    var tileWidth = Std.int(data.width / tilesX);
    var tileHeight = Std.int(data.height / tilesY);

    for (y in 0...tilesY) {
      for (x in 0...tilesX) {
        tilesheet.addTileRect(new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight));
      }
    }

    return tilesheet;
  }
}
