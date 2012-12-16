package util;

import nme.display.Sprite;
import nme.geom.Point;

import tiles.Grid;

class MovementManager {
  public var tileWidth:Int;
  public var tileHeight:Int;
  public var tileScaling:Float;

  public var functions:Array<Void->Void>;

  public var movements:Array<Movement>;

  public var paused:Bool;

  public function new(tileWidth:Int, tileHeight:Int, tileScaling:Float) {
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    this.tileScaling = tileScaling;

    movements = new Array<Movement>();

    functions = new Array<Void->Void>();

    paused = false;
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
    if (!paused) {
      if (movements.length > 0) {
        for (movement in movements) {
          movement.update();
          break;
        }

        var movementIndex = 0;
        while (movementIndex < movements.length) {
          if (movements[movementIndex].currentStep >= movements[movementIndex].steps && movements[movementIndex].started) {
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
  }

  // TODO: This way of pausing and setting animation is tacky
  public function pause() {
    paused = !paused;
    if (movements.length > 0) {
      movements[0].moveObj.anim.changeState(paused ? "idle" : "walk");
    }
  }

  public function determinePath(thing:Unit, layer:Grid<Int>, ?start:Point, ?end:Point) {
    var NULL = 0;
    var PATH = 8;

    if (start == null) {
      start = layer.find(24);
    }

    if (end == null) {
      end = layer.find(32);
    }
    else if (layer.get(Std.int(end.x), Std.int(end.y)) == NULL) {
      return;
    }

    if (start != null && end != null) {
      // Move to the starting point

      var current:Point = start.clone();
      thing.move(1, start.x * tileWidth * tileScaling, start.y * tileHeight * tileScaling);

      var nodes = new Array<Point>();
      var dirs = [new Point(1,0), new Point(0,1), new Point(-1,0), new Point(0,-1)];

      var safteyNet = 1000;
      var dir = 15;
      var travelled:Array<Point> = new Array<Point>();
      travelled.push(current);
      var temp:Point = null;
      var tempWeight:Float = 0;
      var tempDirs:Array<Point> = new Array<Point>();
      var tempWeights:Array<Float> = new Array<Float>();

      var fitness = function(pnt:Point):Float { return Point.distance(pnt, end); };
      var currentFitness = fitness(current);

      while (safteyNet > 0 && !current.equals(end)) {
        tempDirs = new Array<Point>();
        tempWeights = new Array<Float>();
        for (d in 0...dirs.length) {
          temp = current.add(dirs[d]);
          if (layer.get(Std.int(temp.x), Std.int(temp.y)) != NULL) {
            var tempFitness = fitness(temp);
            tempWeight = currentFitness > fitness(temp) ? 10 : 0.2;
            for (i in travelled) {
              if (i.equals(temp)) {
                tempWeight = 0.1;
                break;
              }
            }
            tempDirs.push(temp);
            tempWeights.push(tempWeight);
          }
        }
        if (tempDirs.length > 0) {
          //temp = tempDirs[Std.random(tempDirs.length)];
          temp = Utils.weightedRandom(tempDirs, tempWeights);
          addMovement(thing, temp.x, temp.y, true);
          travelled.push(temp);
          current = temp;
          currentFitness = fitness(current);
        }
        else {
          break;
        }
        safteyNet--;
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

