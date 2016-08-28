package display.entity;

import display.uiElement.TransformMenu;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Transformation
{
	var from:Int;
	var number:Int;
	var time:Float;
	var hero:Hero;
	var isTransforming:Bool;
	var initTransforming:Bool;
	
	public function new(number:Int, hero:Hero, from = -1, first=false) 
	{
		this.from = from;
		this.number = number;
		this.hero = hero;
		
		if (first){
			isTransforming = false;
			initTransforming = true;
			time = -1;
		} else {
			isTransforming = true;
			initTransforming = false;
			time = 50000;
		}
		
	}
	public function update(delta:Int){
		time -= delta;
		if (number != -1 && time < 0){
			hero.setTransformation(-1);
		}
	}
	public function setIsTransforming(b:Bool){
		isTransforming = b;
	}
	public function getIsTransforming():Bool{
		return isTransforming;
	}
	public function setInitTransforming(b:Bool){
		initTransforming = b;
	}
	public function getInitTransforming():Bool{
		return initTransforming;
	}
	public function getNumber(){
		return number;
	}
	public function getFromNumber(){
		return from;
	}
	public function translateNumberTransformation(i:Int, isTo:Bool){
		var r1 = "";
		if (isTo){
			r1 = "from";
		} else {
			r1 = "to";
		}
		
		var r2 = "";
		if (i == TransformMenu.MAGE){
			r2 = "mage";
		} else if (i == TransformMenu.BLUE){
			r2 = "fish";
		}else if (i == TransformMenu.BLACK){
			r2 = "ghost";
		}else if (i == TransformMenu.GREEN){
			r2 = "frog";
		}
		
		
		var r3 = "";
		if (hero.getDirection()){
			r3 = "left";
		} else {
			r3 = "right";
		}
		
		return r1 + "_" + r2 + "_" + r3;
	}
	
	public function firstAnim(i:Int){
		var r1 = "";
		if (hero.getDirection()){
			r1 = "left";
		} else {
			r1 = "right";
		}
		
		
		var r2 = "";
		if (i == TransformMenu.MAGE){
			r2 = "idle";
		} else if (i == TransformMenu.BLUE){
			r2 = "idle_fish";
		} else if (i == TransformMenu.BLACK){
			r2 = "idle_ghost";
		} else if (i == TransformMenu.GREEN){
			r2 = "idle_frog";
		}
		
		
		return r2 + "_" + r1;
	}
}
