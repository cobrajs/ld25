package ;

import nme.geom.Point;

import Unit;

import graphics.Animation;

class Spy extends Unit {
  public var position:Point;
  public var overType:Int;

  public function new() {
    super();

    type = Spy;

    anim = new Animation("spy.xml", this.graphics, false, true);
    anim.update();

    health = 10;

    position = new Point(0, 0);
    overType = 0;
  }

  public override function update() {
    anim.update();
  }

  public override function move(overType:Int, x:Float, y:Float) {
    this.overType = overType;
    this.x = x;
    this.y = y;
  }

  public override function startMove(dest:Point) {
    var diffX = x - dest.x;
    var diffY = y - dest.y;

    if (Math.abs(diffX) > Math.abs(diffY)) {
      if (diffX < 0) {
        anim.changeRotation(0);
      }
      else {
        anim.changeRotation(180);
      }
    }
    else {
      if (diffY < 0) {
        anim.changeRotation(90);
      }
      else {
        anim.changeRotation(270);
      }
    }

    anim.changeState("walk");
  }

  public override function endMove() {
    anim.changeState("idle");
  }
}
