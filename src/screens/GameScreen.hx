package screens;

import nme.events.MouseEvent;
import nme.geom.Point;

import Field;
import Spy;

import util.MovementManager;

import tiles.Tiled;

import ui.Toolbar;
import ui.Button;

class GameScreen extends Screen {
  public var field:Field;

  public var uWidth:Int;
  public var uHeight:Int;

  public var tiles:Tiled;

  private var spy:Spy;

  private var units:Array<Unit>;

  private var mover:MovementManager;

  private var tileScaling:Float;

  private var toolbar:Toolbar;
  private var statusbar:Toolbar;

  public override function new(uWidth:Int, uHeight:Int) {
    super();

    this.uWidth = uWidth;
    this.uHeight = uHeight;

    name = "game";

    tiles = new Tiled("map1.tmx");
    this.tileScaling = uWidth / (tiles.tilesX * tiles.tileWidth);

    field = new Field(uWidth, uHeight, tiles.tilesX, tiles.tilesY);

    tiles.drawLayer("Display", field.background.graphics, tileScaling);

    addChild(field);

    spy = new Spy();

    spy.y = 9 * tiles.tileHeight * tileScaling;

    addChild(spy);

    toolbar = new Toolbar(6, true);
    toolbar.x = uWidth - 64;
    toolbar.y = 0;

    addChild(toolbar);

    var tempButton = new Button(50, 50, 8);
    tempButton.clickAction = function():Void {
      spy.anim.changeState("shoot");
    };
    tempButton.setText("Shoot");

    toolbar.addButton(tempButton, 70, 10);

    tempButton = new Button(50, 50, 8);
    tempButton.clickAction = function():Void {
      spy.anim.changeState("walk");
    };
    tempButton.setText("Walk");

    toolbar.addButton(tempButton, 120, 10);

    tempButton = new Button(50, 50, 8);
    tempButton.clickAction = function():Void {
      spy.anim.changeState("idle");
    };
    tempButton.setText("Idle");

    toolbar.addButton(tempButton, 170, 10);

    mover = new MovementManager(tiles.tileWidth, tiles.tileHeight, tileScaling);

    mover.determinePath(spy, tiles.getLayer("Movement"));


    tempButton = new Button(50, 50, 8);
    tempButton.clickAction = function():Void {
      mover.pause();
    };
    tempButton.setText("Pause");

    toolbar.addButton(tempButton, 220, 10);


    statusbar = new Toolbar(4);
    statusbar.x = uWidth - 64;
    statusbar.y = uHeight - 64;

    addChild(statusbar);

    
    field.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  public override function enter() {
  }

  public override function exit() {
  }

  public override function update() {
    mover.update();
    spy.update();
  }

  public function mouseDown(event:MouseEvent) {
    //mover.addMovement(spy, Std.int(event.localX / (tiles.tileWidth * tileScaling)), Std.int(event.localY / (tiles.tileHeight * tileScaling)), true);
    mover.determinePath(spy, tiles.getLayer("Movement"), 
        new Point(Std.int(spy.x / (tiles.tileWidth * tileScaling)), Std.int(spy.y / (tiles.tileHeight * tileScaling))), 
        new Point(Std.int(event.localX / (tiles.tileWidth * tileScaling)), Std.int(event.localY / (tiles.tileHeight * tileScaling)))
    );
  }
}
