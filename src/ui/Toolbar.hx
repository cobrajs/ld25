package ui;

import nme.display.Sprite;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.events.MouseEvent;

import ui.Button;
import graphics.TilesheetHelper;

class Toolbar extends Sprite{
  public var buttons:Array<Button>;
  public var tilesheet:Tilesheet;
  public var out:Bool;

  public function new(width:Int) {
    super();

    tilesheet = TilesheetHelper.generateTilesheet("toolbar.png", 2, 2, false, true);

    var drawArray:Array<Float> = [0,0,0];
    for (x in 1...width) {
      drawArray.push(x * 64);
      drawArray.push(0);
      drawArray.push(1);
    }
    tilesheet.drawTiles(this.graphics, drawArray);

    out = false;

    buttons = new Array<Button>();

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  private function mouseDown(event:MouseEvent) {
    if (event.localX < 64 && event.localY < 64 && Std.is(event.target, Toolbar)) {
      if (Math.sqrt(Math.pow(event.localX - 64, 2) + Math.pow(event.localY, 2)) < 64) {
        if (out) {
          x += this.width - 64;
        }
        else {
          x -= this.width - 64;
        }
        out = !out;
      }
    }
  }

  public function addButton(button:Button, posX:Float, posY:Float) {
    addChild(button);
    button.x = posX;
    button.y = posY;

    buttons.push(button);
  }
}
