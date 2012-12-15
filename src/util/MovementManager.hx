package util;

import nme.display.Sprite;

class MovementManager {
  public var tileWidth:Int;
  public var tileHeight:Int;

  public var movements:Array<Movement>;

  public function new(tileWidth:Int, tileHeight:Int) {
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    movements = new Array<Movement>();
  }

  public function addMovement(thing:Unit, x:Float, y:Float, ?tilePlace:Bool = false) {
    if (tilePlace) {
      movements.push(new Movement(thing, x * tileWidth, y * tileHeight, tileWidth, tileHeight, 100));
    }
    else {
      movements.push(new Movement(thing, x, y, tileWidth, tileHeight, 100));
    }
  }

  public function update() {
    for (movement in movements) {
      movement.update();
      break;
    }

    var movementIndex = 0;
    while (movementIndex < movements.length) {
      if (movements[movementIndex].currentStep >= movements[movementIndex].steps) {
        movements.splice(movementIndex, 1);
      }
      else {
        movementIndex++;
      }
    }
  }
}

class Movement {
  public var fromX:Float;
  public var fromY:Float;

  public var toX:Float;
  public var toY:Float;

  public var currentX:Float;
  public var currentY:Float;

  public var tileX:Int;
  public var tileY:Int;

  public var tileWidth:Int;
  public var tileHeight:Int;

  public var moveX:Float;
  public var moveY:Float;

  public var steps:Int;
  public var currentStep:Int;

  public var moveObj:Unit;

  public var started:Bool;

  public function new(moveObj:Unit, toX:Float, toY:Float, tileWidth:Int, tileHeight:Int, time:Int) {
    this.moveObj = moveObj;

    started = false;

    this.toX = toX;
    this.toY = toY;

    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    steps = 100;
    currentStep = 0;

  }

  public function begin() {
    started = true;

    this.fromX = moveObj.x == null ? 0 : moveObj.x;
    this.fromY = moveObj.y == null ? 0 : moveObj.y;

    this.currentX = this.fromX;
    this.currentY = this.fromY;

    this.tileX = Std.int(this.currentX / tileWidth);
    this.tileY = Std.int(this.currentY / tileHeight);

    this.moveX = (toX - fromX ) / steps;
    this.moveY = (toY - fromY) / steps;
  }

  public function update() {
    if (!started) {
      begin();
    }
    if (currentStep < steps) {
      currentStep++;
      this.currentX += this.moveX;
      this.currentY += this.moveY;

      moveObj.move(1, this.currentX, this.currentY);
    }
  }
}

