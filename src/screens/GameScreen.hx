package screens;

import nme.events.MouseEvent;
import Field;
import Spy;

import util.MovementManager;

import tiles.Tiled;

class GameScreen extends Screen {
  public var field:Field;

  public var uWidth:Int;
  public var uHeight:Int;

  public var tiles:Tiled;

  private var spy:Spy;

  private var mover:MovementManager;

  private var tileScaling:Float;

  public override function new(uWidth:Int, uHeight:Int) {
    super();

    this.uWidth = uWidth;
    this.uHeight = uHeight;

    name = "game";

    tiles = new Tiled("map1.tmx");
    this.tileScaling = uWidth / (tiles.tilesX * tiles.tileWidth);

    field = new Field(uWidth, uHeight, tiles.tilesX, tiles.tilesY);

    tiles.drawLayer("Display", field.background.graphics, tileScaling);

    addChild(field);

    spy = new Spy();

    addChild(spy);

    mover = new MovementManager(tiles.tileWidth, tiles.tileHeight, tileScaling);
    
    addEventListener(MouseEvent.MOUSE_UP, mouseUp);
  }

  public override function enter() {
  }

  public override function exit() {
  }

  public override function update() {
    mover.update();
    spy.update();
  }

  public function mouseUp(event:MouseEvent) {
    mover.addMovement(spy, Std.int(event.localX / (tiles.tileWidth * tileScaling)), Std.int(event.localY / (tiles.tileHeight * tileScaling)), true);
  }
}
