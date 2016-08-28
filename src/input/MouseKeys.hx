package input;

import openfl.events.MouseEvent;
import openfl.geom.Point;
/**
 * ...
 * @author Roelandt Sebastien
 */
class MouseKeys
{
	static var eventsAdded;
	static var down:Bool;
	static var x:Float;
	static var y:Float;

	public static function init(){
		eventsAdded = false;
		down = false;
		addEvents();
	}
	
	public static function destroy() {
		eventsAdded = false;
		down = false;
		removeEvents();
	}
	
	static function removeEvents() {
		if( !eventsAdded )
			return;
			
		eventsAdded = false;
		var stage = flash.Lib.current.stage;
		stage.removeEventListener(MouseEvent.MOUSE_UP, onKeyUp);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
	}
	
	static function addEvents(){
		if( eventsAdded )
			return;
			
		eventsAdded = true;
		var stage = flash.Lib.current.stage;
		stage.addEventListener(MouseEvent.MOUSE_UP, onKeyUp);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
	}
	
	static function onKeyDown(e:MouseEvent) {
		down = true;
	}
	
	static function onKeyUp(e:MouseEvent) {
		down = false;
	}
	
	static function onMove(e:MouseEvent) {
		x = e.stageX;
		y = e.stageY;
	}
	
	public static function isDown() {
		return down;
	}
	
	public static function getXY():Point{
		return new Point(x,y);
	}
	
}