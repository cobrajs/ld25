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

  public var tilesheets:IntHash<Tilesheet>;
  public var currentTilesheet:Tilesheet;
  public var currentRotation:Int;

  public function new(xmlName:String, drawSpace:Graphics, ?flipped:Bool = false, ?rotated:Bool = false) {
    states = new Hash<AnimationState>();

    this.drawSpace = drawSpace;

    var xml = new Fast(Xml.parse(Assets.getText("assets/" + xmlName)).firstElement());

    var tempTempData = Assets.getBitmapData(xml.node.info.node.source.innerData);
    var tilesheetData = new BitmapData(tempTempData.width, tempTempData.height, true);
    tilesheetData.copyPixels(tempTempData, new Rectangle(0, 0, tempTempData.width, tempTempData.height), new Point(0, 0), null, null, true);

    ImageOpts.keyBitmapData(tilesheetData);

    tilesheets = new IntHash<Tilesheet>();
    currentTilesheet = new Tilesheet(tilesheetData);
    currentRotation = 0;

    tilesheets.set(0, currentTilesheet);

    if (flipped) {
      tilesheets.set(-1, new Tilesheet(ImageOpts.flipImageData(tilesheetData)));
    }

    if (rotated) {
      for (x in [90, 180, 270]) {
        tilesheets.set(x, new Tilesheet(ImageOpts.rotateImageData(tilesheetData, x)));
      }
    }

    tilesX = Std.parseInt(xml.node.info.node.tilesx.innerData);
    tilesY = Std.parseInt(xml.node.info.node.tilesy.innerData);

    tileWidth = Std.int(tilesheetData.width / tilesX);
    tileHeight = Std.int(tilesheetData.height / tilesY);

    for (y in 0...tilesY) {
      for (x in 0...tilesX) {
        tilesheets.get(0).addTileRect(new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight));
        if (flipped) {
          tilesheets.get(-1).addTileRect(new Rectangle((tilesX - x - 1) * tileWidth, y * tileHeight, tileWidth, tileHeight));
        }
        if (rotated) {
          tilesheets.get(90).addTileRect(new Rectangle(Math.floor((tilesX - y - 1) * tileWidth), x * tileHeight, tileWidth, tileHeight));
          tilesheets.get(180).addTileRect(new Rectangle(Math.floor((tilesX - x - 1) * tileWidth), Math.floor((tilesY - y - 1) * tileHeight), tileWidth, tileHeight));
          tilesheets.get(270).addTileRect(new Rectangle(Math.floor(y * tileWidth), Math.floor((tilesY - x - 1) * tileHeight), tileWidth, tileHeight));
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
    drawSpace.clear();
    currentTilesheet.drawTiles(drawSpace, [0, 0, currentState.current]);
  }

  public function draw(image:Dynamic, ?x:Int = 0, ?y:Int = 0) {
    if (Std.is(image, Graphics)) {
      currentTilesheet.drawTiles(image, [x, y, currentState.current]);
    }
    else if (Std.is(image, Sprite)) {
      currentTilesheet.drawTiles(image.graphics, [x, y, currentState.current]);
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

  public function changeRotation(rotation:Int) {
    currentRotation = rotation;
    currentTilesheet = tilesheets.get(rotation);
    drawSpace.clear();
    currentTilesheet.drawTiles(drawSpace, [0, 0, currentState.current]);
  }

  public function turnRight() {
    changeRotation(currentRotation + 90 >= 360 ? 0 : currentRotation + 90);
  }

  public function turnLeft() {
    changeRotation(currentRotation - 90 < 0 ? 270 : currentRotation - 90);
  }

  public function flip() {
    changeRotation(currentRotation == 0 ? -1 : 0);
  }
}

private class AnimationState {
  private var start:Int;
  private var end:Int;
  private var length:Int;
  public var current:Int;
  private var delay:Float;
  private var changeDelay:Float;
  private var delayOffset:Int;
  private var lastUpdate:Float;
  public var name:String;

  public function new(name:String, start:Int, end:Int, ?changeDelay:Int = 500) {
    this.name = name;
    this.start = start;
    this.end = end;
    this.length = end - start + 1;
    this.current = 0;
    this.delay = 0;
#if (neko || cpp)
    this.changeDelay = changeDelay / 1000;
#else
    this.changeDelay = changeDelay;
#end
    this.delayOffset = 1;
#if (neko || cpp)
    this.lastUpdate = Sys.time();
#else 
    this.lastUpdate = Date.now().getTime();
#end
  }

  public function update() {
    if (length > 1) {
      var change = false;
      var offset:Float = 0;
      if (lastUpdate != -1) {
#if (neko || cpp)
        var currentDate = Sys.time();
#else 
        var currentDate = Date.now().getTime();
#end
        offset = currentDate - lastUpdate;
        lastUpdate = currentDate;
      }
      else {
#if (neko || cpp)
        lastUpdate = Sys.time();
#else 
        lastUpdate = Date.now().getTime();
#end
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
  }

  public function reset() {
    current = start;
    delay = 0;
    lastUpdate = -1;
  }
}
