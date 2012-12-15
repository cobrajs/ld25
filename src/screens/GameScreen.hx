package screens;

import Field;

class GameScreen extends Screen {
  public var field:Field;

  public var uWidth:Int;
  public var uHeight:Int;

  public override function new(uWidth:Int, uHeight:Int) {
    super();

    this.uWidth = uWidth;
    this.uHeight = uHeight;

    name = "game";

    field = new Field(uWidth, uHeight, Std.int(uWidth/ 40), Std.int(uHeight / 40));

    addChild(field);
  }

  public override function enter() {
  }

  public override function exit() {
  }

  public override function update() {
  }
}
