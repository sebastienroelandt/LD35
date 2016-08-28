package display.uiElement;

import display.entity.ParcheminEntity;
import display.scene.Scene;

/**
 * ...
 * @author Roelandt Sebastien
 */
class MapManager extends Iimage
{
	var tiles:Array<Iimage>;
	var isWalkable:Array<Array<Bool>>;
	public var map:Array<Array<Int>>;
	
	var transformMenu:TransformMenu;
	public var parchemins:Array<ParcheminEntity>;
	public var textManager:TextManager;
	
	public function new(map:Array<Array<Int>>, parcheminsID:Array<Int>, textManager: TextManager) 
	{
		super();
		this.map = map;
		tiles = new Array<Iimage>();
		isWalkable = new Array<Array<Bool>>();
		
		for (j in 0...map.length){
			var line = map[j];
			var isWalkableLine = new Array<Bool>();
			for (i in 0...line.length){
				var id = line[i];
				var image = new StaticImage(Scene.imageStorage, "tileset",id , i * 32, j * 32);
				isWalkableLine.push(Constant.isWalkable(id));
				tiles.push(image);
				this.addChild(image);
			}
			isWalkable.push(isWalkableLine);
		}
		
		parchemins = new Array<ParcheminEntity>();
		for (index in 0...parcheminsID.length){
			var id = parcheminsID[index];
			var pe = new ParcheminEntity(Scene.imageStorage, "parchemin_animation", Constant.getParcheminColor(id), Constant.getParcheminX(id), Constant.getParcheminY(id));
			parchemins.push(pe);
			this.addChild(pe);
		}
		
		this.textManager = textManager;
		addChild(textManager);
		
	}
	
	public function getIsWalkable(i,j):Bool{
		return isWalkable[i][j];
	}
	
	override public function update(delta:Int) 
	{
		super.update(delta);
		for (p in parchemins){
			p.update(delta);
		}
		transformMenu.update(delta);
		textManager.update(delta);
	}
	
	public function setTransformenu(t:TransformMenu)
	{
		transformMenu = t;
	}
	
	public function getTransformenu()
	{
		return transformMenu;
	}
}