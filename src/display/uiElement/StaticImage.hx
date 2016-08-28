package display.uiElement;

import data.ImageStorage;
import display.uiElement.Iimage;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import imageDisplay.*;

/**
 * ...
 * @author Roelandt Sebastien
 */
class StaticImage extends Iimage
{
	var isWalkable:Bool;
	
	public function new(imageStorage:ImageStorage, groupName:String, id:Int, x:Int, y:Int) 
	{
		super();
		var bitmap:Bitmap = new Bitmap(imageStorage.getBitmapByID(groupName, id));
		isWalkable = false;
		if (groupName == "tileset") {
			isWalkable = Constant.isWalkable(id);
		}
		addChild(bitmap);
		bitmap.x = x;
		bitmap.y = y;
	}
	
	override function update(delta:Int){
		super.update(delta);
	}
	
}