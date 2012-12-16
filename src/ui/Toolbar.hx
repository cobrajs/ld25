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

  public function new() {
    super();

    tilesheet = TilesheetHelper.generateTilesheet("toolbar.png", 2, 2, false, true);

    tilesheet.drawTiles(this.graphics, [0,0,0, 64,0,1, 128,0,1, 192,0,1]);

    out = false;

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  private function mouseDown(event:MouseEvent) {
    if (out) {
      x += 128;
    }
    else {
      x -= 128;
    }
    out = !out;
  }
}
