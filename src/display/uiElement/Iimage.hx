package display.uiElement;

import data.ImageStorage;
import openfl.display.Sprite;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Iimage extends Sprite
{
	public function update(delta:Int){
		
	}
	
	public function setX(x:Float){
		this.x = x - 20;
	}
	
	public function setY(y:Float){
		this.y = y - 20;
	}
}