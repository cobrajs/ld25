package ;

// Libraries
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.system.System;
import nme.ui.Keyboard;

import screens.ScreenManager;

import tiles.Grid;

class Main extends Sprite {

  private var screenManager:ScreenManager;

  public function new() {
    super();

    addEventListener(Event.ADDED_TO_STAGE, addedToStage);
  }

  private function construct():Void {
    addEventListener(Event.ENTER_FRAME, enterFrame);

    screenManager = new ScreenManager(stage);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDown);
    stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
    stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
  }
  
  private function update():Void {
    screenManager.update();
  }


  // -------------------------------------------------- 
  //                  Event Handlers
  // -------------------------------------------------- 

  private function addedToStage(event:Event):Void {
    construct();
  }

  private function enterFrame(event:Event):Void {
    update();
  }

  private function stageMouseMove(event:MouseEvent):Void {
  }

  private function stageMouseUp(event:MouseEvent):Void {
  }

  private function stageKeyDown(event:KeyboardEvent):Void {
    if (event.keyCode == Keyboard.ESCAPE) {
      System.exit(0);
    }
  }

}
