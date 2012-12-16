package mooks;

import Unit;

/*
   A standard basic Mook unit.

   Can only fire his gun in a straight line, and is very bad at it

*/
class Mook extends Unit() {
  public function new() {
    super();

    type = Mook;
  }
}

