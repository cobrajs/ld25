package screens;

import Field;
import Spy;

import tiles.Tiled;

class GameScreen extends Screen {
  public var field:Field;

  public var uWidth:Int;
  public var uHeight:Int;

  public var tiles:Tiled;

  private var spy:Spy;

  public override function new(uWidth:Int, uHeight:Int) {
    super();

    this.uWidth = uWidth;
    this.uHeight = uHeight;

    name = "game";

    field = new Field(uWidth, uHeight, Std.int(uWidth/ 40), Std.int(uHeight / 40));

    tiles = new Tiled("map1.tmx");

    tiles.drawLayer("Display", field.background.graphics, uWidth / (tiles.tilesX * tiles.tileWidth));

    addChild(field);

    spy = new Spy();

    addChild(spy);

  }

  public override function enter() {
  }

  public override function exit() {
  }

  public override function update() {
  }
}
