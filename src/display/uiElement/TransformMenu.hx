package display.uiElement;

import display.entity.Hero;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import data.* ;
import openfl.text.*;
import openfl.Lib;
import openfl.Assets;
import input.Keys;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Roelandt Sebastien
 */

//@:font("font/04B_03__.TTF") class OpenSansFont extends Font { }

class TransformMenu extends Iimage
{
	public static var MAGE = -1;
	public static var BLACK = 0;
	public static var GREEN = 1;
	public static var BLUE = 2;
	public static var OTHER = 3;
	public static var EXIT = 4;
	
	private var parcheminBitmap:Array<Bitmap>;
	private var parcheminText:Array<TextField>;
	private var parcheminQuantity:Array<Int>;
	
	private var textFormat:TextFormat;
	private var selected:Int;
	private var selectorBitmap:Bitmap;
	
	public var isSelectingTransformation:Bool;
	public var isSpaceUp:Bool;
	
	public var hero:Hero;
	
	public function new(imageStorage:ImageStorage, groupName:String, selector:String, x:Int, y:Int) 
	{
		super();
		selected = 0;
		parcheminBitmap = new Array<Bitmap>();
		parcheminText = new Array<TextField>();
		parcheminQuantity = new Array<Int>();

		textFormat = new TextFormat(Assets.getFont("font/04B_03__.TTF").fontName, 24, 0xAD5110);
		textFormat.align = TextFormatAlign.CENTER;
		
		addElementMenu(imageStorage, groupName, BLACK);
		addElementMenu(imageStorage, groupName, GREEN);
		addElementMenu(imageStorage, groupName, BLUE);
		addExitMenu(imageStorage, groupName, EXIT);
		
		selectorBitmap = new Bitmap(imageStorage.getBitmapByID(selector, 0));
		selectorBitmap.x = parcheminBitmap[selected].x-6;
		selectorBitmap.y = parcheminBitmap[selected].y - 6;
		selectorBitmap.alpha = 0;
		addChild(selectorBitmap);
		
		isSelectingTransformation = false;
		isSpaceUp = true;
		
		this.x = x;
		this.y = y;
	}
	
	override public function update(delta:Int) 
	{
		super.update(delta);
		
		if (Keys.isClick(Keyboard.SPACE)){
			isSpaceUp = false;
			if (!isSelectingTransformation){
				isSelectingTransformation = true;
				selectorBitmap.alpha = 1 ;
			} else {
				if (selected == parcheminBitmap.length - 1){
					isSelectingTransformation = false;
					selectorBitmap.alpha = 0;
				}
				if (parcheminQuantity[selected]>0){
					parcheminQuantity[selected] -= parcheminQuantity[selected];
					parcheminText[selected].text = Std.string(parcheminQuantity[selected]);
					hero.setTransformation(selected);
					selectorBitmap.alpha = 0;
				}
			}
		}
		
		if (isSelectingTransformation == false){
			parcheminBitmap[parcheminBitmap.length - 1].alpha = 0;
		} else {
			parcheminBitmap[parcheminBitmap.length - 1].alpha = 1;
			
			if (Keys.isClick(Keyboard.LEFT)){
				selected --;
				if (selected < 0){
					selected = parcheminBitmap.length - 1;
				}
				selectorBitmap.x = parcheminBitmap[selected].x-6;
				selectorBitmap.y = parcheminBitmap[selected].y - 6;
			}
			if (Keys.isClick(Keyboard.RIGHT)){
				selected ++;
				if (selected > parcheminBitmap.length - 1){
					selected = 0;
				}
				selectorBitmap.x = parcheminBitmap[selected].x-6;
				selectorBitmap.y = parcheminBitmap[selected].y-6;
			}
		}
	}
	
	public function setIsSelectingTransformation(b:Bool)
	{
		isSelectingTransformation = b;
	}
	
	public function getIsSelectingTransformation():Bool
	{
		return isSelectingTransformation;
	}
	
	private function addElementMenu(imageStorage:ImageStorage, groupName:String, enumElement:Int){
		
		var blackParchemin = new Bitmap(imageStorage.getBitmapByID(groupName, enumElement));
		parcheminBitmap.push(blackParchemin);
		parcheminQuantity.push(0);
		
		var blackText = new TextField();
		
		blackText.defaultTextFormat = textFormat;
		blackText.text = "0";
		blackText.setTextFormat(textFormat);
		blackText.width = 30;
		blackText.selectable = false;
		parcheminText.push(blackText);
		
		blackParchemin.x = 64 + 96 * enumElement;
		blackParchemin.y = 10;
		blackText.x = blackParchemin.x + 35;
		blackText.y = blackParchemin.y + 30;
		
		addChild(blackParchemin);
		addChild(blackText);
	}
	
	private function addExitMenu(imageStorage:ImageStorage, groupName:String, enumElement:Int){
		var blackParchemin = new Bitmap(imageStorage.getBitmapByID(groupName, enumElement));
		parcheminBitmap.push(blackParchemin);
		parcheminQuantity.push(0);
		addChild(blackParchemin);
		blackParchemin.x = 64 + 96 * enumElement;
		blackParchemin.y = 10;
	}
	
	public function setHero(h:Hero){
		hero = h;
	}
	
	public function addParchemin(n:Int){
		parcheminQuantity[n] ++;
		parcheminText[n].text = Std.string(parcheminQuantity[n]);
	}
	
}