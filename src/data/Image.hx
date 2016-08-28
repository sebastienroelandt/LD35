package data;

import spritesheet.Spritesheet;
import openfl.display.BitmapData;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Image
{
	public var id:Int;
	public var name:String;
	
	public var spriteSheet:Spritesheet;
	public var bipmapData(get, null):BitmapData;
	
	public function new(name:String, id:Int) 
	{
		this.id = id;
		this.name = name;
	}
	
	public function get_bipmapData(){
		return spriteSheet.getFrame(id).bitmapData;
	}
	public function getSpritesheet(){
		return spriteSheet;
	}
	public function getName(){
		return name;
	}
}