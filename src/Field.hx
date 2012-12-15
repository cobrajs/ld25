package ;

import nme.display.Sprite;
import nme.display.Shape;

class Field extends Sprite {

  public var background:Shape;
  public var grid:Shape;

  public var uWidth:Int;
  public var uHeight:Int;

  public var tilesX:Int;
  public var tilesY:Int;

  public var tileWidth:Int;
  public var tileHeight:Int;

  public function new(width:Int, height:Int, tilesX:Int, tilesY:Int) {
    super();

    uWidth = width;
    uHeight = height;

    this.tilesX = tilesX;
    this.tilesY = tilesY;

    tileWidth = Std.int(width / tilesX);
    tileHeight = Std.int(height / tilesY);

    background = new Shape();
    grid = new Shape();

    var gfx = grid.graphics;
    gfx.lineStyle(1, 0x555555, 0.5);
    for (y in 0...tilesY) {
      for (x in 0...tilesX) {
        gfx.drawRect(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
      }
    }
    gfx.lineStyle();

    var gfx = background.graphics;
    gfx.beginFill(0xDDDDDD);
    gfx.drawRect(0, 0, uWidth, uHeight);

    addChild(background);
    addChild(grid);
  }
}
