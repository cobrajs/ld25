package screens;

import nme.display.Stage;

import screens.GameScreen;

class ScreenManager {
  public var screens:Hash<Dynamic>;

  public var current:Dynamic;

  public function new(stage:Stage) {
    var gameScreen = new GameScreen(stage.stageWidth, stage.stageHeight);

    screens = new Hash<Dynamic>();

    screens.set("game", gameScreen);

    current = gameScreen;

    stage.addChild(gameScreen);
  }

  public function changeScreen(name:String) {
  }
}
