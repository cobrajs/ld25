package tiles;

import nme.geom.Point;

class Grid<T> {
  public var data:Array<Array<T>>;
  public var width:Int;
  public var height:Int;
  public var defaultValue:T;

  public function new(?width:Int, ?height:Int, ?defaultValue:T) {
    data = new Array<Array<T>>();

    if (width != null && height != null) {
      this.width = width;
      this.height = height;
      this.defaultValue = defaultValue;
      for (y in 0...height) {
        data.push(new Array<T>());
        for (x in 0...width) {
          data[y].push(defaultValue);
        }
      }
    }
  }

  public function set(t:T, x:Int, y:Int) {
    if (y >= data.length) {
      for (i in 0...(y - data.length + 1)) {
        data.push(new Array<T>());
      }
      this.height = data.length;
    }

    if (x >= data[y].length) {
      for (i in 0...(x - data[y].length + 1)) {
        data[y].push(defaultValue);
      }
      this.width = data[y].length;
    }

    data[y][x] = t;
  }

  public function get(x:Int, y:Int):T {
    if (y < 0 || x < 0) {
      return defaultValue;
    }
    if (y >= data.length || x >= data[0].length) {
      return defaultValue;
    }
    return data[y][x];
  }


  public function find(t:T):Point {
    for (v in iterPos()) {
      if (get(v[0], v[1]) == t) {
        return new Point(v[0], v[1]);
      }
    }
    return null;
  }


  //
  // Iterator generators
  //
  public function iter() {
    return new GridIterator(this);
  }

  public function iterPos() {
    return new GridIteratorPos(this);
  }
}


private class GridIterator<T> {
  var i:Int;
  var grid:Grid<T>;

  public function new(grid:Grid<T>) {
    i = 0;
    this.grid = grid;
  }

  public function hasNext() { return (Std.int(i / grid.width) < grid.height); }
  public function next() { return grid.data[Std.int(i / grid.width)][(i++) % grid.width]; }
}


private class GridIteratorPos<T> {
  var i:Int;
  var grid:Grid<T>;

  public function new(grid:Grid<T>) {
    i = 0;
    this.grid = grid;
  }

  public function hasNext() { return (Std.int(i / grid.width) < grid.height); }
  public function next():Array<Int> { return [i % grid.width, Std.int((i++) / grid.width)]; }
}
