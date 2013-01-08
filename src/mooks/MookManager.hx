package mooks;

import Unit;
import mooks.Mook;

import nme.geom.Point;

class MookManager {
  public var data:Array<Unit>;

  public function new() {
    data = new Array<Unit>();
  }

  public function addMook(type:UnitType, position:Point):Unit {
    var temp:Unit;
    switch(type) {
      case Mook:
        temp = new Mook();
      default:
        temp = new Mook();
    }

    temp.move(1, position.x, position.y);
    data.push(temp);
    return temp;
  }

  public function update() {
    for (mook in data) {
      mook.update();
    }
  }
}
