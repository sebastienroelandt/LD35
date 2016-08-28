package data;

import openfl.display.BitmapData;
import spritesheet.Spritesheet;
import spritesheet.importers.BitmapImporter;
import spritesheet.data.BehaviorData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import spritesheet.AnimatedSprite;

/**
 * ...
 * @author Roelandt Sebastien
 */
class ImageStorage
{
	public var allGroups:Array<ImageGroup>;

	public function new() 
	{
		allGroups = new Array<ImageGroup>();
	}
	
	public function addImages(groupName:String, source:BitmapData, startX:Int, startY:Int, width:Int, height:Int, repeatX=1, repeatY=1){
		var group = getGroup(groupName);
		
		var cutBitmapData:BitmapData = new BitmapData(width*repeatX, height*repeatY);
		cutBitmapData.copyPixels(source, new Rectangle(startX, startY, width*repeatX, height*repeatY), new Point(0, 0));
		var spritesheet:Spritesheet = BitmapImporter.create(cutBitmapData, repeatX, repeatY, width, height);
		
		for (y in 0...repeatY){
			for (x in 0...repeatX){
				var image:Image = new Image(groupName + "_" + group.getNextID(),group.getNextID());
				image.spriteSheet = spritesheet;
				group.push(image);
			}
		}
	}
	
	public function initAnimation(groupName:String, source:BitmapData, startX:Int, startY:Int, width:Int, height:Int, repeatX=1, repeatY=1){
		var group = getGroup(groupName);
		var cutBitmapData:BitmapData = new BitmapData(width*repeatX, height*repeatY);
		cutBitmapData.copyPixels(source, new Rectangle(startX, startY, width*repeatX, height*repeatY), new Point(0, 0));

		var spritesheet:Spritesheet = BitmapImporter.create(cutBitmapData, repeatX, repeatY, width, height);

		var image:Image = new Image(groupName,group.getNextID());
		image.spriteSheet = spritesheet;
		group.push(image);
	}
	
	public function addAnimation(groupName:String, name:String, image:Array<Int>, times:Array<Int>, loop = true){
		var group = getGroup(groupName, false);
		if (group != null){
			var spritesheet = group.groupImages[0].getSpritesheet();
			spritesheet.addBehavior(new BehaviorData(name, inverseTimeTable(image, times), loop, 1));
		}
	}
	
	private function inverseTimeTable(image:Array<Int>,times:Array<Int>):Array<Int>{
		trace("image:" + image);
		trace("times:" + times);
		var finalTable = new Array<Int>();
		for(index in 0...times.length){
			var time = times[index];
			for(i in 0...time){
				finalTable.push(image[index]);
			}
		}
		trace("finalTable:" + finalTable);
		return finalTable;
	}
	
	private function getGroup(groupName:String, ?add=true):ImageGroup{
		for(g in allGroups){
			if(g.get_name()==groupName){
				return g;
			}
		}
		if(add){
			var newGroup = new ImageGroup(groupName);
			allGroups.push(newGroup);
			return newGroup;
		}
		return null;
	}
	
	public function getBitmapByID(groupName:String, id:Int ):BitmapData{
		var group = getGroup(groupName, false);
		if (group != null){
			return group.getImageByID(id);
		}
		return null;
	}
	
	public function getSpritesheet(groupName:String, name:String):Spritesheet{
		var group = getGroup(groupName, false);
		if (group != null){
			return group.getSpritesheet(name);
		}
		return null;
	}
	
	public function getEndBehavior():BehaviorData{
		var animatedSprite = new AnimatedSprite(getSpritesheet("hero", "end"), false);
		animatedSprite.showBehavior("end");
		return animatedSprite.currentBehavior;
	}
}

class ImageGroup
{
	public var name(get,null):String;
	public var groupImages:Array<Image>;
	
	public function new(name:String){
		this.name = name;
		this.groupImages = new Array<Image>();
	}
	public function get_name():String{
		return name;
	}
	public function push(i:Image){
		groupImages.push(i);
	}
	public function getImageByID(id:Int):BitmapData{
		if (id < groupImages.length){
			return groupImages[id].bipmapData;
		}
		return null;
	}
	public function getSpritesheet(name:String):Spritesheet{
		for (i in groupImages){
			if (name == i.getName()){
				return i.getSpritesheet();
			}
		}
		return null;
	}
	public function getNextID():Int{
		return groupImages.length;
	}
	
}