package input;

import openfl.events.KeyboardEvent;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Keys
{
	static var eventsAdded;
	static var downCodes = new Map< Int, Bool >();
	static var upCodes =  new Map< Int, Bool >();
	static var isEspaced =  new Map< Int, Bool >();

	public static function init() {
		eventsAdded = false;
		downCodes = new Map();
		upCodes = new Map();
		addEvents();
	}
	
	public static function destroy() {
		downCodes = new Map();
		upCodes = new Map();
		removeEvents();
	}
	
	static function removeEvents() {
		if( !eventsAdded )
			return;
			
		eventsAdded = false;
		var stage = flash.Lib.current.stage;
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	static function addEvents(){
		if( eventsAdded )
			return;
			
		eventsAdded = true;
		var stage = flash.Lib.current.stage;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp); 
	}
	
	static function onKeyDown(e:KeyboardEvent) {
		onKey(e.keyCode, true);
	}
	
	static function onKeyUp(e:KeyboardEvent) {
		onKey(e.keyCode, false);
	}
	
	public static function onKey( code:Int, down:Bool ) {
		if ( down ) {
			downCodes.set(code, true);
			upCodes.set(code, false);
		} else {
			upCodes.set(code, true);
			isEspaced.set(code,true);
			downCodes.set(code, false);
		}
	}
	
	public static function update(){
	}
	
	public static function isDown(k:Int) {
		return downCodes.get(k);
	}
	
	public static function isUp(k:Int) {
		return upCodes.get(k);
	}
	
	public static function isClick(k:Int) {
		if (downCodes.get(k) && isEspaced.get(k)){
			isEspaced.set(k, false);
			return true;
		}
		return false;
	}
}