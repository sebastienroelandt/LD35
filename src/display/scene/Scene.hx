package display.scene;
import data.ImageStorage;
import display.uiElement.Iimage;
import openfl.display.Sprite;

import input.MouseKeys;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Scene extends Sprite
{
	public static var imageStorage:ImageStorage;
	public var images:Array<Iimage>;
	
	public function new() 
	{	
		super();
		images = new Array<Iimage>();
	}
	
	public function update(delta){
		for (i in images){
			i.update(delta*10);
		}
	}
	
	public function addImage(i:Iimage){
		images.push(i);
		addChild(i);
	}
	
}