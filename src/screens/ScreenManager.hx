package screens;

import nme.display.Stage;

import screens.GameScreen;

class ScreenManager {
  public var screens:Hash<Screen>;

  public var current:Screen;

  public function new(stage:Stage) {
    var gameScreen = new GameScreen(stage.stageWidth, stage.stageHeight);

    screens = new Hash<Screen>();

    screens.set("game", gameScreen);

    current = gameScreen;

    stage.addChild(gameScreen);
  }

  public function changeScreen(name:String) {
  }
  
  public function update() {
    current.update();
  }
}
