package tiles;

import nme.display.Tilesheet;
import nme.display.Graphics;
import nme.Assets;

import graphics.TilesheetHelper;

class Tiled {
  public var tilesheet:Tilesheet;

  public var tilesX:Int;
  public var tilesY:Int;

  public var tileWidth:Int;
  public var tileHeight:Int;

  public var layers:Hash<Grid<Int>>;

  public function new(xmlFilename:String) {
    var rawXML = Xml.parse(Assets.getText("assets/maps/" + xmlFilename));
    var fast = new haxe.xml.Fast(rawXML.firstElement());

    tileWidth = Std.parseInt(fast.att.tilewidth);
    tileHeight = Std.parseInt(fast.att.tileheight);

    var tileset = fast.node.tileset;
    var tilesImage = tileset.node.image.att.source;
    
    if (tilesImage.indexOf("/") > -1) {
      var splitFilename = tilesImage.split("/");
      tilesImage = splitFilename[splitFilename.length - 1];
    }

    var tilesImageTilesX = Std.int(Std.parseInt(tileset.node.image.att.width) / tileWidth);
    var tilesImageTilesY = Std.int(Std.parseInt(tileset.node.image.att.height) / tileHeight);


    tilesX = Std.parseInt(fast.att.width);
    tilesY = Std.parseInt(fast.att.height);

    tilesheet = TilesheetHelper.generateTilesheet(tilesImage, tilesImageTilesX, tilesImageTilesY);

    layers = new Hash<Grid<Int>>();

    for (layer in fast.nodes.layer) {
      var name = layer.att.name;
      var data = layer.node.data.innerData;
      var elems = data.split(",");
      var tempFull = new Grid<Int>(tilesX, tilesY, 0);
      var tempArray;

      for (y in 0...tilesY) {
        for (x in 0...tilesX) {
          tempFull.set(Std.parseInt(elems[y * tilesX + x]) - 1, x, y);
        }
      }

      layers.set(name, tempFull);
    }
  }


  public function drawLayer(layerName:String, gfx:Graphics, ?scaling:Float = 1) {
    if (layers.exists(layerName)) {
      var layer = layers.get(layerName);
      var drawArray:Array<Float> = new Array<Float>();

      for (v in layer.iterPos()) {
        drawArray.push(v[0] * tileWidth * scaling);
        drawArray.push(v[1] * tileHeight * scaling);
        drawArray.push(layer.get(v[0], v[1]));
        drawArray.push(scaling);
      }

      tilesheet.drawTiles(gfx, drawArray, Tilesheet.TILE_SCALE);
    }
  }
}
