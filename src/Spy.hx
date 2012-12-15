package ;

import nme.geom.Point;

import Unit;

import graphics.Animation;

class Spy extends Unit {
  public var health:Int;

  public var position:Point;
  public var overType:Int;

  public function new() {
    super();

    anim = new Animation("spy.xml", this.graphics);
    anim.update();

    health = 10;

    position = new Point(0, 0);
    overType = 0;
  }

  public function update() {
  }

  public function move(x:Int, y:Int) {

  }
}
