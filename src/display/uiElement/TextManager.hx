package display.uiElement;

import openfl.display.Sprite;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.Assets;
import display.entity.Hero;

/**
 * ...
 * @author Roelandt Sebastien
 */
class TextManager extends Iimage
{
	var textFormat:TextFormat;
	var textFields:Array<TextField>;
	var times:Array<Int>;
	var followHero:Array<Bool>;
	var hero:Hero;

	public function new() 
	{
		super();
		this.hero = null;
		textFormat = new TextFormat(Assets.getFont("font/04B_03__.TTF").fontName, 24, 0xAD5110);
		times = new Array<Int>();
		textFields = new Array<TextField>();
		followHero = new Array<Bool>();
	}
	
	override public function update(delta:Int){
		super.update(delta);
		
		var index = textFields.length -1;
		while (index >= 0){
			times[index] -= delta;
			var time = times[index];
			if (followHero[index]){
				textFields[index].x = hero.x + 30;
				textFields[index].y = hero.y - 40;
			}
			if (time < 0){
				removeChild(textFields[index]);
				textFields.remove(textFields[index]);
				times.remove(times[index]);
				followHero.remove(followHero[index]);
			}
			index--;
		}
	}
	
	public function setHero(hero:Hero){
		this.hero = hero;
	}
	
	public function addTexte(s:String, time:Int, x:Int, y:Int, follow:Bool=false){
		var t = new TextField();
		
		t.defaultTextFormat = textFormat;
		t.text = s;
		t.setTextFormat(textFormat);
		t.selectable = false;
		t.width = 500;
		t.x = x;
		t.y = y;
		t.wordWrap = true;
		
		textFields.push(t);
		times.push(time);
		followHero.push(follow);
		addChild(t);
	}
	
}