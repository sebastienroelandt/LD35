package;

import imageDisplay.*;
import display.*;
import data.ImageStorage;
import display.scene.*;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.text.*;
import openfl.Assets;
import openfl.events.Event;
import view.*;
import input.*;
import openfl.ui.Keyboard;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Main extends Sprite 
{
	var lastTime: Int;
	
	var menuScene:Menu;
	var actualScene:BasicScene;
	var isInMenu:Bool;
	var sceneNumber:Int;
	
	var menuSound:Sound;
	var menuChannel:SoundChannel;
	var beginSound:Sound;
	var beginChannel:SoundChannel;
	var endSound:Sound;
	var endChannel:SoundChannel;
	var playSound:Sound;
	var playChannel:SoundChannel;
	
	public function new() 
	{
		super();
		sceneNumber = 0;
		isInMenu = true;
		
		var imageStorage = new ImageStorage();
		imageStorage = new ImageStorage();
		var b:BitmapData = Assets.getBitmapData("img/myTileset.png");
		imageStorage.initAnimation("hero", b, 0, 0, 46, 66, 6, 14);
		imageStorage.addAnimation("hero", "idle_right", [0, 1], [20, 3]);
		imageStorage.addAnimation("hero", "idle_left", [3, 2], [20, 3]);
		imageStorage.addAnimation("hero", "move_right", [6, 7, 8, 9], [1, 1, 1, 1]);
		imageStorage.addAnimation("hero", "move_left", [12, 13, 14, 15], [1, 1, 1, 1]);
		imageStorage.addAnimation("hero", "from_mage_right", [18, 19, 20, 21, 22, 23, 22, 23], [1, 1, 1, 1, 1, 3, 2, 2], false);
		imageStorage.addAnimation("hero", "to_mage_right", [23, 22, 21, 20, 19, 18], [1, 1, 1, 1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "fish_right", [24, 25, 26, 27], [1, 1, 1, 1]);
		imageStorage.addAnimation("hero", "to_fish_right", [33, 32, 31, 30], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "from_fish_right", [30, 31, 32, 33], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "fish_left", [39, 38, 37,36], [1, 1, 1, 1]);
		imageStorage.addAnimation("hero", "end", [0, 1], [1, 1], false);
		imageStorage.addAnimation("hero", "idle_fish_right", [42, 43], [20, 3]);
		imageStorage.addAnimation("hero", "idle_fish_left", [45, 44], [20, 3]);
		imageStorage.addAnimation("hero", "from_mage_left", [53, 52, 51, 50, 49, 48, 49, 48], [1, 1, 1, 1, 1, 3, 2, 2], false);
		imageStorage.addAnimation("hero", "to_mage_left", [48, 49, 50, 51, 50, 51], [1, 1, 1, 1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "to_fish_left", [56, 57, 58, 59], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "from_fish_left", [59, 58, 57, 56], [1, 1, 1, 1], false);
		
		var d = 10 * 6;
		imageStorage.addAnimation("hero", "to_ghost_right", [d+3, d+2, d+1, d], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "from_ghost_right", [d, d + 1, d + 2, d + 3], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "idle_ghost_right", [d, d], [1, 1]);
		imageStorage.addAnimation("hero", "ghost_right", [d, d], [1, 1]);
		
		d +=6;
		imageStorage.addAnimation("hero", "to_ghost_left", [d, d+1, d+2, d+3], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "from_ghost_left", [d+3, d+2, d+1, d], [1, 1, 1, 1], false);
		imageStorage.addAnimation("hero", "idle_ghost_left", [d + 3, d + 3], [1, 1]);
		imageStorage.addAnimation("hero", "ghost_left", [d + 3, d + 3], [1, 1]);
		
		d +=6;
		imageStorage.addAnimation("hero", "to_frog_right", [d+5, d+4, d], [1, 1, 1], false);
		imageStorage.addAnimation("hero", "from_frog_right", [d, d+4, d+5], [1, 1, 1], false);
		imageStorage.addAnimation("hero", "idle_frog_right", [d, d + 3], [20, 3]);
		imageStorage.addAnimation("hero", "frog_right", [d, d+1, d+2, d+1, d], [1, 1, 2, 1, 1], false);
		
		d +=6;
		imageStorage.addAnimation("hero", "to_frog_left", [d, d+1, d+5], [1, 1, 1], false);
		imageStorage.addAnimation("hero", "from_frog_left", [d+5, d+1, d], [1, 1, 1], false);
		imageStorage.addAnimation("hero", "idle_frog_left", [d+5, d + 2], [20, 3]);
		imageStorage.addAnimation("hero", "frog_left", [d+5, d+4, d+3, d+4, d+5], [1, 1, 2, 1, 1], false);
		
		
		var t:BitmapData = Assets.getBitmapData("img/tileset.png");
		imageStorage.addImages("tileset", t, 0, 0, 32, 32, 8, 3);
		
		var p:BitmapData = Assets.getBitmapData("img/parchemin_animation.png");
		var parcheminSpeed = 3;
		imageStorage.initAnimation("parchemin_animation", p, 0, 0, 80, 80, 6, 6);
		imageStorage.addAnimation("parchemin_animation", "black", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed]);
		imageStorage.addAnimation("parchemin_animation", "green", [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], [parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed]);
		imageStorage.addAnimation("parchemin_animation", "blue", [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35], [parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed, parcheminSpeed]);

		var g:BitmapData = Assets.getBitmapData("img/ghost.png");
		imageStorage.addImages("ghost", g, 0, 0, 46, 68);
		
		var f:BitmapData = Assets.getBitmapData("img/fish.png");
		imageStorage.initAnimation("fish", f, 0, 0, 48, 48, 4,2 );
		imageStorage.addAnimation("fish", "swim", [0, 1, 2, 3], [8, 8, 8, 8]);
		imageStorage.addAnimation("fish", "begin", [4, 5, 6, 7], [1, 1, 1, 1]);
		imageStorage.addAnimation("fish", "end", [7, 6, 5, 4], [1, 1, 1, 1]);
		
		var ui:BitmapData = Assets.getBitmapData("img/parchemin_ui.png");
		imageStorage.addImages("parchemin_ui", ui, 76,0,64,62,5);
		imageStorage.addImages("parchemin_selector", ui, 0, 0, 76, 74);
		
		var menu:BitmapData = Assets.getBitmapData("img/menu.png");
		imageStorage.addImages("menu", menu, 0, 0, 789, 628);
		
		var start:BitmapData = Assets.getBitmapData("img/start_button.png");
		imageStorage.addImages("start", start, 0, 0, 215, 105, 1, 2);
		
		menuSound = Assets.getSound("sound/accueil2.wav");
		menuChannel = menuSound.play();
		menuChannel.soundTransform = new SoundTransform(0.1);
		
		beginSound = Assets.getSound("sound/debut_sort.wav");
		endSound = Assets.getSound("sound/fin_sort.wav");
		playSound = Assets.getSound("sound/jeux.wav");
		
		Scene.imageStorage = imageStorage;
		
		menuScene = new Menu();
		actualScene = new BasicScene(sceneNumber); 
		flash.Lib.current.stage.color = 0x000000;
		
		this.addChild(menuScene);
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public static function main() 
	{		
		Keys.init();
		MouseKeys.init();
		Constant.init();
		
		
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}

	public function onEnterFrame(e:Event):Void
	{
		var delta = Lib.getTimer() - lastTime;
		
		Keys.update();
		
		if (isInMenu){
			menuScene.update(delta);
			if(menuScene.isEnd()){
				isInMenu = false;
				actualScene = new BasicScene(sceneNumber);
				this.addChild(actualScene);
				this.removeChild(menuScene);
				menuChannel.stop();
				playChannel = playSound.play(0,1);
				playChannel.soundTransform = new SoundTransform(0.1);
				playChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}else if (actualScene.hero.end){
			sceneNumber ++;
			if (sceneNumber < 5){
				this.removeChild(actualScene);
				actualScene = new BasicScene(sceneNumber);
				this.addChild(actualScene);
				
			} else {
				sceneNumber = 0;
				isInMenu = true;
				menuScene.setIsEnd(false);
			//	this.removeChild(actualScene);
				this.addChild(menuScene);
				playChannel.stop();
				menuChannel = menuSound.play(0,1);
			}
		}
		if (Keys.isClick(Keyboard.R) || actualScene.hero.isDied){
			
			this.removeChild(actualScene);
			var diedReason = actualScene.hero.diedReason;
			actualScene = new BasicScene(sceneNumber);
			actualScene.map.textManager.addTexte(diedReason, 25000, 800, 800, true);
			this.addChild(actualScene);
		}
		actualScene.update(delta*Constant.ACCELERATOR);
		
		lastTime = Lib.getTimer();
	}
	
	function onSoundComplete(event:Event){
		event.currentTarget.removeEventListener(event.type, onSoundComplete);
		playChannel = playSound.play(0,1);
		playChannel.soundTransform = new SoundTransform(0.1);
		playChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
	}
}
