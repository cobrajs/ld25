package util;

import nme.display.Sprite;
import nme.geom.Point;

class MovementManager {
  public var tileWidth:Int;
  public var tileHeight:Int;
  public var tileScaling:Float;

  public var functions:Array<Void->Void>;

  public var movements:Array<Movement>;

  public function new(tileWidth:Int, tileHeight:Int, tileScaling:Float) {
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    this.tileScaling = tileScaling;

    movements = new Array<Movement>();

    functions = new Array<Void->Void>();
  }

  public function addMovement(thing:Unit, x:Float, y:Float, ?tilePlace:Bool = false) {
    if (tilePlace) {
      movements.push(new Movement(thing, x * (tileWidth * tileScaling), y * (tileHeight * tileScaling), tileWidth, tileHeight, 2));
    }
    else {
      movements.push(new Movement(thing, x, y, tileWidth, tileHeight, 100));
    }
  }

  public function addAction(func:Void->Void) {
    functions.push(func);
  }

  public function update() {
    if (movements.length > 0) {
      for (movement in movements) {
        movement.update();
        break;
      }

      var movementIndex = 0;
      while (movementIndex < movements.length) {
        if (movements[movementIndex].currentStep >= movements[movementIndex].steps) {
          movements[movementIndex].end();
          movements.splice(movementIndex, 1);
        }
        else {
          movementIndex++;
        }
      }
    }
    else {
      if (functions.length > 0) {
        var funcIndex = 0;
        while (funcIndex < functions.length) {
          functions[funcIndex]();
          functions.splice(funcIndex, 1);
        }
      }
    }
  }

  public function determinePath(thing:Unit, layer:Grid<Int>) {
    var start:Point = new Point(0,0);
    var end:Point   = new Point(0,0);

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

  public var speed:Int;

  public function new(moveObj:Unit, toX:Float, toY:Float, tileWidth:Int, tileHeight:Int, speed:Int) {
    this.moveObj = moveObj;

    started = false;

    this.toX = toX;
    this.toY = toY;

    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    currentStep = 0;

    this.speed = speed;
  }

  public function begin() {
    started = true;

    this.fromX = moveObj.x;
    this.fromY = moveObj.y;

    this.currentX = this.fromX;
    this.currentY = this.fromY;

    this.tileX = Std.int(this.currentX / tileWidth);
    this.tileY = Std.int(this.currentY / tileHeight);

    var diffX = toX - fromX;
    var diffY = toY - fromY;

    steps = Math.floor(Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2)) / speed);

    this.moveX = diffX / steps;
    this.moveY = diffY / steps;

    moveObj.startMove(new Point(this.toX, this.toY));
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

  public function end() {
    moveObj.endMove();
  }
}

