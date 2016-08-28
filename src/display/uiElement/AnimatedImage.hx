package display.uiElement;

import data.ImageStorage;
import spritesheet.AnimatedSprite;
import imageDisplay.*;

/**
 * ...
 * @author Roelandt Sebastien
 */
class AnimatedImage extends Iimage
{
	var animated:AnimatedSprite;

	public function new(imageStorage:ImageStorage, groupName:String, name:String , x:Int, y:Int) 
	{
		super();
		
		animated = new AnimatedSprite(imageStorage.getSpritesheet(groupName, groupName), true);
		animated.showBehavior(name);
		addChild(animated);
		this.x = x;
		this.y = y;
	}
	
	override public function update(delta:Int){
		super.update(delta);
		animated.update(delta);
	}
	
}