package display.uiElement;

import display.scene.Scene;
import openfl.display.Sprite;
import input.MouseKeys;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Button extends Sprite
{
	
	private var isActivated:Bool;
	private var initial:Iimage;
	private var hover:Iimage;
	
	public function new() 
	{
		super();
		
		isActivated = false;
		initial = new StaticImage(Scene.imageStorage, "start", 1, 100, 100);
		hover = new StaticImage(Scene.imageStorage, "start", 2, 100, 100);
		addChild(initial);
		addChild(hover);
	}
	
	public function destroy(){
		initial = null;
		hover = null;
	}
	
	public function update(delta){
		var xy = MouseKeys.getXY();
		if (initial.x < xy.x && xy.x < initial.x + initial.width && xy.y > initial.y && xy.y < initial.y + initial.height){
			hover.alpha = 1;
			initial.alpha = 0;
		} else {
			hover.alpha = 0;
			initial.alpha = 1;
		}
	}
}