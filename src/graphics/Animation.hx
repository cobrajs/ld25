package graphics;

import nme.Assets;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.display.Graphics;

import haxe.xml.Fast;

class Animation {
  public var states:Hash<AnimationState>;
  public var currentState:AnimationState;

  public var drawSpace:Graphics;

  public var tilesX:Int;
  public var tilesY:Int;

  public var tileWidth:Int;
  public var tileHeight:Int;

  public var tilesheet:Tilesheet;
  public var tilesheetFlipped:Tilesheet;

  public function new(xmlName:String, drawSpace:Graphics, ?flipped:Bool = false) {
    states = new Hash<AnimationState>();

    this.drawSpace = drawSpace;

    var xml = new Fast(Xml.parse(Assets.getText("assets/" + xmlName)).firstElement());

    var tilesheetData = Assets.getBitmapData(xml.node.info.node.source.innerData);

    tilesheet = new Tilesheet(tilesheetData);
    if (flipped) {
      tilesheetFlipped = new Tilesheet(ImageOpts.flipImageData(tilesheetData));
    }

    tilesX = Std.parseInt(xml.node.info.node.tilesx.innerData);
    tilesY = Std.parseInt(xml.node.info.node.tilesy.innerData);

    tileWidth = Std.int(tilesheetData.width / tilesX);
    tileHeight = Std.int(tilesheetData.height / tilesY);

    for (y in 0...tilesY) {
      for (x in 0...tilesX) {
        tilesheet.addTileRect(new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight));
        if (flipped) {
          tilesheetFlipped.addTileRect(new Rectangle((tilesX - x - 1) * tileWidth, y * tileHeight, tileWidth, tileHeight));
        }
      }
    }

    for (state in xml.node.states.nodes.state) {
      var name = state.att.name;
      var temp = new AnimationState(name, Std.parseInt(state.att.start), Std.parseInt(state.att.end), Std.parseInt(state.att.delay));
      states.set(name, temp);
      if (currentState == null) {
        currentState = temp;
      }
    }
  }

  public function update() {
    currentState.update();
    tilesheet.drawTiles(drawSpace, [0, 0, currentState.current]);
  }

  public function draw(image:Dynamic, ?x:Int = 0, ?y:Int = 0) {
    if (Std.is(image, Graphics)) {
      tilesheet.drawTiles(image, [x, y, currentState.current]);
    }
    else if (Std.is(image, Sprite)) {
      tilesheet.drawTiles(image.graphics, [x, y, currentState.current]);
    }
  }

  public function changeState(state:String, ?reset:Bool = true) {
    if (states.exists(state)) {
      if (reset) {
        currentState.reset();
      }
      currentState = states.get(state);
    }
  }
}

private class AnimationState {
  private var start:Int;
  private var end:Int;
  public var current:Int;
  private var delay:Int;
  private var changeDelay:Int;
  private var delayOffset:Int;
  private var lastUpdate:Float;
  public var name:String;

  public function new(name:String, start:Int, end:Int, ?changeDelay:Int = 500) {
    this.name = name;
    this.start = start;
    this.end = end;
    this.current = 0;
    this.delay = 0;
    this.changeDelay = 500;
    this.delayOffset = 1;
    this.lastUpdate = Date.now().getTime();
  }

  public function update() {
    var change = false;
    var offset = 0;
    if (lastUpdate != -1) {
      var currentDate = Date.now().getTime();
      offset = Math.floor(currentDate - lastUpdate);
      lastUpdate = currentDate;
    }
    else {
      lastUpdate = Date.now().getTime();
    }

    delay += offset;
    if (delay > changeDelay * delayOffset) {
      delay = 0;
      current += 1;
      if (current > end) {
        current = start;
      }
      change = true;
    }
  }

  public function reset() {
    current = start;
    delay = 0;
    lastUpdate = -1;
  }
}
