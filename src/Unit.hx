package ;

import nme.display.Sprite;

import graphics.Animation;

class Unit extends Sprite {
  public var anim:Animation;
  public var type:Int;

  public function new() {
    super();
  }
  
  public function move(overType:Int, x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }
}
