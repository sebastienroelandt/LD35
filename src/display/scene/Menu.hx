package display.scene;
import display.uiElement.Button;
import display.uiElement.StaticImage;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import input.Keys;
import openfl.ui.Keyboard;
import input.MouseKeys;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Menu extends Scene
{
	var button:Button;
	
	var end:Bool;
	
	public function new() 
	{
		super();
		end = false;
		super.graphics.beginFill(0x000000);
		super.graphics.drawRect(0, 0, 800, 640);
		
		addChild(new StaticImage(Scene.imageStorage, "menu", 0, 0, 0));
		
		var textFormat = new TextFormat(Assets.getFont("font/04B_03__.TTF").fontName, 24, 0xAD5110);
		textFormat.align = TextFormatAlign.CENTER;
		
		var t = new TextField();
		
		t.defaultTextFormat = textFormat;
		t.text = "Enester, the unexpected magician ! \n By Sebastien Roelandt";
		t.setTextFormat(textFormat);
		t.selectable = false;
		t.width = 800;
		t.x = 0;
		t.y = 50;
		t.wordWrap = true;
	
		addChild(t);
		
		
		var textFormat2 = new TextFormat(Assets.getFont("font/04B_03__.TTF").fontName, 18, 0xAD5110);
		textFormat2.align = TextFormatAlign.CENTER;
		
		var t2 = new TextField();
		
		t2.defaultTextFormat = textFormat2;
		t2.text = "Instructions: \n Use Arrow keys to move \n Press Space to use parchment \n Press r to restart the level.";
		t2.setTextFormat(textFormat);
		t2.selectable = false;
		t2.width = 400;
		t2.x = 0;
		t2.y = 380;
		t2.wordWrap = true;
	
		addChild(t2);
		
		
		var t3 = new TextField();
		
		t3.defaultTextFormat = textFormat2;
		t3.text = "Press Space to Start";
		t3.setTextFormat(textFormat);
		t3.selectable = false;
		t3.width = 800;
		t3.x = 0;
		t3.y = 260;
		t3.wordWrap = true;
		
		addChild(t3);
	}
	
	override public function update(delta) 
	{
		super.update(delta);
		if (Keys.isDown(Keyboard.SPACE)){
			end = true;
		}
	}
	
	public function isEnd():Bool{
		return end;
	}
	
	public function setIsEnd(b:Bool){
		end = b;
	}
	
}