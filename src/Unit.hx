package ;

import nme.display.Sprite;
import nme.geom.Point;

import graphics.Animation;

enum UnitType {
  Mook;
  EliteMook;
  CamoMook;
  Sniper;
  Dragon;
  Spy;
}

class Unit extends Sprite {
  public var anim:Animation;
  public var type:UnitType;

  //
  // Unit stats
  //
  public var health:Float; // 0 - 1 scale

  public function new() {
    super();
  }
  
  public function move(overType:Int, x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }

  public function endMove():Void {
  }

  public function startMove(dest:Point):Void {
  }

  public function update() {
    anim.update();
  }
}
