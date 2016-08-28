package display.entity;

import display.uiElement.AnimatedImage;
import data.ImageStorage;
import display.uiElement.TransformMenu;
/**
 * ...
 * @author Roelandt Sebastien
 */
class ParcheminEntity extends AnimatedImage
{
	var type:Int;
	var available:Bool;
	
	public function new(imageStorage:ImageStorage, groupName:String, type:Int , x:Int, y:Int) 
	{
		this.type = type;
		var name = "";
		if (type == TransformMenu.BLACK){
			name = "black";
		} else if (type == TransformMenu.GREEN){
			name = "green";
		} else if (type == TransformMenu.BLUE){
			name = "blue";
		}
		available = true;
		super(imageStorage, groupName, name , x, y);
	}
		
	override public function update(delta:Int){
		super.update(delta);
		animated.update(delta);
	}
	
	public function getType():Int{
		return type;
	}
	
	public function isTouched(){
		animated.alpha = 0;
		available = false;
	}
	
	public function getAvailable():Bool{
		return available;
	}
}