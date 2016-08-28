package display.scene;
import data.ImageStorage;
import display.entity.Hero;
import display.scene.Scene;
import display.uiElement.AnimatedImage;
import display.uiElement.Button;
import display.uiElement.StaticImage;
import display.uiElement.TextManager;
import display.uiElement.TransformMenu;
import display.uiElement.MapManager;
import input.Keys;
import openfl.geom.Point;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Roelandt Sebastien
 */
class BasicScene extends Scene
{
	public var map:MapManager;
	public var hero:Hero;
	var transformMenu:TransformMenu;
	

	public function new(id:Int) 
	{
		super();
		
		super.graphics.beginFill(0x1e2936);
		super.graphics.drawRect(0, 0, 800, 640);
		
		var peIDs = new Array<Int>();
		if (id == 0){
			peIDs.push(0);
		}else if (id == 1){
			peIDs.push(1);
			peIDs.push(2);
		}
		else if (id == 2){
			peIDs.push(3);
			peIDs.push(4);
		}
		else if (id == 3){
			peIDs.push(5);
			peIDs.push(6);
			peIDs.push(7);
			peIDs.push(8);
		}
		else if (id == 4){
			peIDs.push(9);
			peIDs.push(10);
			peIDs.push(11);
			peIDs.push(12);
		}
		map = new MapManager(Constant.getMap(id),peIDs,new TextManager());
		addChild(map);
		
		transformMenu = new TransformMenu(Scene.imageStorage, "parchemin_ui", "parchemin_selector", 0, 0);
		map.setTransformenu(transformMenu);
		addChild(transformMenu);
		
		var p = Constant.getStartingPoint(id);
		hero = new Hero(Scene.imageStorage, "hero", "idle", Std.int(p.x), Std.int(p.y), map);
		addChild(hero);
	}
	
	override public function update(delta) 
	{
		super.update(delta);
		map.update(delta);
		if (Keys.isDown(Keyboard.LEFT)){
			//ghost.x --;
		}
		if (Keys.isDown(Keyboard.RIGHT)){
			//ghost.x ++;
		}
		hero.update(delta);
	}
}