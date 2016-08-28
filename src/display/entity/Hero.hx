package display.entity;

import display.uiElement.*;
import data.*;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import input.Keys;

/**
 * ...
 * @author Roelandt Sebastien
 */
class Hero extends AnimatedImage
{
	public var cx			: Int;
	public var cy			: Int;
	public var xr			: Float;
	public var yr			: Float;
	
	public var dx			: Float;
	public var dy			: Float;
	public var xx			: Float;
	public var yy			: Float;
	
	var map:MapManager;
	var imageStorage:ImageStorage;
	var rec:Sprite;
	var actualBehavior:String;
	var isLeft:Bool;
	var isPause:Bool;
	var isSelectingTransformation:Bool;
	
	var transformation:Transformation;
	
	var time:Int;
	
	public var diedReason:String;
	public var isDied:Bool;
	public var end:Bool;
	
	public function new(imageStorage:ImageStorage, groupName:String, name:String , x:Int, y:Int, map:MapManager){
		super(imageStorage, groupName, name , x, y);
		
		resetTime();
		
		this.map = map;
		this.imageStorage = imageStorage;
		map.getTransformenu().setHero(this);
		transformation = new Transformation(-1, this,-1, true);
		
		rec = new Sprite();
        rec.graphics.lineStyle(2, 0xFF0000);
        rec.graphics.beginFill(0x0000FF, 1);
        rec.graphics.drawRect(0,0,2,2);
		//addChild(rec);
		cx = x;
		cy = y;
		xr = yr = 0.5;
		dx = dy = 0;
		isPause = false;
		isDied = false;
		diedReason = "";
		
		Keys.onKey(32,false);
		
		map.textManager.setHero(this);
	}
	
	public function resetTime(){
		time = 20000;
	}
	
	public function setCoordinates(x,y) {
		xx = x;
		yy = y;
		cx = Std.int(xx/Constant.GRID);
		cy = Std.int(yy/Constant.GRID);
		xr = (xx-cx*Constant.GRID) / Constant.GRID;
		yr = (yy-cy*Constant.GRID) / Constant.GRID;
	}
	
	public function hasCollision(cx:Int,cy:Int):Bool
	{
		if ( cx < 0 || cx >= Constant.WIDTH / Constant.GRID || cy >= Constant.HEIGHT / Constant.GRID ){
			return true;
		}
		else {
			if (map.getIsWalkable(cy, cx)){
				return false;
			}
			return true;
		}	
	}
	
	public function onGround() {
		return (hasCollision(cx,cy+1)) && yr>=0;
	}
	
	override public function update(delta:Int){
		if (!isPause && !map.getTransformenu().getIsSelectingTransformation() && !transformation.getIsTransforming()){
			checkCollisionWithParcheminEntity();
			transformation.update(delta);
			super.update(delta);
			
			if (transformation.getNumber() == TransformMenu.MAGE){
				updateMage(delta);
			}
			if (transformation.getNumber() == TransformMenu.BLUE){
				updateFish(delta);
			}
			if (transformation.getNumber() == TransformMenu.BLACK){
				updateGhost(delta);
			}
			if (transformation.getNumber() == TransformMenu.GREEN){
				updateFrog(delta);
			}
			
		} else if(transformation.getIsTransforming()) {
			if (!transformation.getInitTransforming()){
				transformation.setInitTransforming(true);
				animated.showBehaviors([transformation.translateNumberTransformation(transformation.getFromNumber(), true)
					, transformation.translateNumberTransformation(transformation.getNumber(), false), "end"]);
			} else if(transformation.getIsTransforming()){
				animated.update(delta);
				if (animated.currentBehavior.name == "end"){
					animated.showBehavior(transformation.firstAnim(transformation.getNumber()));
					transformation.setIsTransforming(false);
					map.getTransformenu().setIsSelectingTransformation(false);
					dy = dx = 0;
				}
			}
		}
		
		end = onFinish();
	}
	
	public function setTransformation(n:Int){
		trace("CHANGE");
		var previous = transformation.getNumber();
		var t = new Transformation(n, this, previous);
		transformation = t;
		if (previous == TransformMenu.BLACK){
			if (onWall()){
				isDied = true;
				diedReason = Constant.getMessage(Constant.DIED_WALL);
			}
		}
	}
	
	private function updateMage(delta:Int){
		var frictX = 0.90;
		var frictY = 0.94;
		var gravity = 0.04;
		var speed = 0.01;
		
		var isMove = false;
		if( Keys.isDown(Keyboard.LEFT)){
			dx -= speed;
			if (actualBehavior != "move_left"){
				animated.showBehavior("move_left");
				actualBehavior = "move_left";
			}
			isMove = true;
			isLeft = true;
		}
		if( Keys.isDown(Keyboard.RIGHT)){
			dx += speed;
			if (isMove){
				isMove = false;
			} else {
				isMove = true;
				if (actualBehavior != "move_right"){
					animated.showBehavior("move_right");
					actualBehavior = "move_right";
				}
			}
			isLeft = false;
		}
		if( Keys.isDown(Keyboard.UP) && onGround()){
			dy = -0.5;
		}
		if (!isMove){
			if (isLeft && actualBehavior != "idle_left"){
				actualBehavior = "idle_left";
				animated.showBehavior("idle_left");
			} else if(!isLeft && actualBehavior != "idle_right"){
				actualBehavior = "idle_right";
				animated.showBehavior("idle_right");
			}
		}
		
		if (!onWater()){
			resetTime();
		}
		time -= delta;
		checkDied();

		// X component
		xr+=dx;
		dx*=frictX;
		if( hasCollision(cx-1,cy) && xr<=0.4 ) {
			dx = 0;
			xr = 0.4;
		}
		rec.x = cx-1 + width/2;
		rec.y = cy;
		if( hasCollision(cx+1,cy) && xr>=0.6 ) {
			dx = 0;
			xr = 0.6;
		}
		while( xr<0 ) {
			cx--;
			xr++;
		}
		while( xr>1 ) {
			cx++;
			xr--;
		}
		
		// Y component
		dy+=gravity;
		yr+=dy;
		dy*=frictY;
		if( hasCollision(cx,cy-2) && yr<=0 ) {
			dy = 0;
			yr = 0;
		}
		if( (hasCollision(cx,cy+1) || hasCollision(cx+1,cy+1) && xr>=0.7 || hasCollision(cx-1,cy+1) && xr<=0.1)  && yr>=0 ) {
			dy  = 0;
			yr = 0;
		}
		while( yr<0 ) {
			cy--;
			yr++;
		}
		while( yr>1 ) {
			cy++;
			yr--;
		}
			
		xx = Std.int((cx+xr)*Constant.GRID);
		yy = Std.int((cy+yr)*Constant.GRID);
		this.x = xx - width/2;
		this.y = yy - height + Constant.GRID;
	}
	
	private function updateFish(delta:Int){
		var frictX = 0.90;
		var frictY = 0.94;
		var speed = 0.01;
		var gravity = 0.04;
		
		var isMove = false;
		if( Keys.isDown(Keyboard.LEFT) && onWater()){
			dx -= speed;
			if (actualBehavior != "fish_left"){
				animated.showBehavior("fish_left");
				actualBehavior = "fish_left";
			}
			isMove = true;
			isLeft = true;
		}
		if( Keys.isDown(Keyboard.RIGHT) && onWater()){
			dx += speed;
			if (isMove){
				isMove = false;
			} else {
				isMove = true;
				if (actualBehavior != "fish_right"){
					animated.showBehavior("fish_right");
					actualBehavior = "fish_right";
				}
			}
			isLeft = false;
		}
		if( Keys.isDown(Keyboard.UP) && onWater()){
			dy -= speed;
			if (isMove){
				isMove = false;
			} else {
				isMove = true;
			}
		}
		if( Keys.isDown(Keyboard.DOWN)){
			dy += speed;
			if (isMove){
				isMove = false;
			} else {
				isMove = true;
			}
		}
		if (!isMove){
			if (isLeft && actualBehavior != "idle_fish_left"){
				actualBehavior = "idle_fish_left";
				animated.showBehavior("idle_fish_left");
			} else if(!isLeft && actualBehavior != "idle_fish_right"){
				actualBehavior = "idle_fish_right";
				animated.showBehavior("idle_fish_right");
			}
		}
		
		// X component
		xr+=dx;
		dx*=frictX;
		if( hasCollision(cx-1,cy) && xr<=0.4 ) {
			dx = 0;
			xr = 0.4;
		}
		rec.x = cx-1 + width/2;
		rec.y = cy;
		if( hasCollision(cx+1,cy) && xr>=0.6 ) {
			dx = 0;
			xr = 0.6;
		}
		while( xr<0 ) {
			cx--;
			xr++;
		}
		while( xr>1 ) {
			cx++;
			xr--;
		}
		
		// Y component
		if (!onWater()){
			dy+=gravity;
		}
		yr+=dy;
		dy*=frictY;
		if( hasCollision(cx,cy-2) && yr<=0 ) {
			dy = 0;
			yr = 0;
		}
		if( (hasCollision(cx,cy+1) || hasCollision(cx+1,cy+1) && xr>=0.7 || hasCollision(cx-1,cy+1) && xr<=0.1)  && yr>=0 ) {
			dy  = 0;
			yr = 0;
		}
		while( yr<0 ) {
			cy--;
			yr++;
		}
		while( yr>1 ) {
			cy++;
			yr--;
		}
			
		xx = Std.int((cx+xr)*Constant.GRID);
		yy = Std.int((cy+yr)*Constant.GRID);
		this.x = xx - width/2;
		this.y = yy - height + Constant.GRID;
	}
	
	private function updateGhost(delta:Int)
	{
		var frictX = 0.90;
		var frictY = 0.94;
		var gravity = 0.04;
		var speed = 0.01;
		
		var isMove = false;
		if( Keys.isDown(Keyboard.LEFT)){
			dx -= speed;
			if (actualBehavior != "ghost_left"){
				animated.showBehavior("ghost_left");
				actualBehavior = "ghost_left";
			}
			isMove = true;
			isLeft = true;
		}
		if( Keys.isDown(Keyboard.RIGHT)){
			dx += speed;
			if (isMove){
				isMove = false;
			} else {
				isMove = true;
				if (actualBehavior != "ghost_right"){
					animated.showBehavior("ghost_right");
					actualBehavior = "ghost_right";
				}
			}
			isLeft = false;
		}

		if (!isMove){
			if (isLeft && actualBehavior != "idle_ghost_left"){
				actualBehavior = "idle_ghost_left";
				animated.showBehavior("idle_ghost_left");
			} else if(!isLeft && actualBehavior != "idle_ghost_right"){
				actualBehavior = "idle_ghost_right";
				animated.showBehavior("idle_ghost_right");
			}
		}
		
		while( xr<0 ) {
			cx--;
			xr++;
		}
		while( xr>1 ) {
			cx++;
			xr--;
		}
		
		// X component
		xr+=dx;
		dx *= frictX;
		
		xx = Std.int((cx+xr)*Constant.GRID);
		yy = Std.int((cy+yr)*Constant.GRID);
		this.x = xx - width/2;
		this.y = yy - height + Constant.GRID;
		if (this.x < 0) x = 0;
		if (this.x > 800) x = 800 - 40;
	}
	
	private function updateFrog(delta:Int)
	{
		var frictX = 0.90;
		var frictY = 0.94;
		var gravity = 0.04;
		var speed = 0.03;
		
		var isMove = false;
		if( Keys.isDown(Keyboard.LEFT) ){
			if (actualBehavior != "frog_left"){
				animated.showBehavior("idle_frog_left");
				actualBehavior = "frog_left";
			}
			if (!onGround()){
				dx -= speed;
				isMove = true;
			}
			isLeft = true;
		}
		if( Keys.isDown(Keyboard.RIGHT) && !onGround()){
			
			if (isMove){
				isMove = false;
			} else {
				if (!onGround()){
					dx += speed;
					isMove = true;
				}
				if (actualBehavior != "frog_right"){
					animated.showBehavior("idle_frog_right");
					actualBehavior = "frog_right";
				}
			}
			isLeft = false;
		}
		if(Keys.isDown(Keyboard.UP) && onGround()){
			dy = -0.8;
			if (isLeft){
				actualBehavior = "jump_frog_left";
				animated.showBehaviors(["frog_left","idle_frog_left"]);
			} else {
				actualBehavior = "jump_frog_right";
				animated.showBehaviors(["frog_right","idle_frog_right"]);
			}
		}
		
		// X component
		xr+=dx;
		dx*=frictX;
		if( hasCollision(cx-1,cy) && xr<=0.4 ) {
			dx = 0;
			xr = 0.4;
		}
		rec.x = cx-1;
		rec.y = cy;
		if( hasCollision(cx+1,cy) && xr>=0.6 ) {
			dx = 0;
			xr = 0.6;
		}
		while( xr<0 ) {
			cx--;
			xr++;
		}
		while( xr>1 ) {
			cx++;
			xr--;
		}
		
		// Y component
		dy+=gravity;
		yr+=dy;
		dy*=frictY;
		if( hasCollision(cx,cy-2) && yr<=0 ) {
			dy = 0;
			yr = 0;
		}
		if( (hasCollision(cx,cy+1) || hasCollision(cx+1,cy+1) && xr>=0.7 || hasCollision(cx-1,cy+1) && xr<=0.1)  && yr>=0 ) {
			dy  = 0;
			yr = 0;
		}
		while( yr<0 ) {
			cy--;
			yr++;
		}
		while( yr>1 ) {
			cy++;
			yr--;
		}
			
		xx = Std.int((cx+xr)*Constant.GRID);
		yy = Std.int((cy+yr)*Constant.GRID);
		this.x = xx - width/2;
		this.y = yy - height + Constant.GRID;
	}
	
	public function getDirection():Bool{
		return isLeft;
	}
	
	public function checkCollisionWithParcheminEntity(){
		for (p in map.parchemins){
			if (p.getAvailable() && p.x < rec.x + this.x && p.x + p.width > rec.x + this.x &&
				p.y < rec.y + this.y && p.y + p.height > rec.y + this.y){
				map.getTransformenu().addParchemin(p.getType());
				p.isTouched();
			}
		}
	}
	
	private function onWater():Bool{
		if ( map.map[cy + 1][cx] == 14 || map.map[cy + 1][cx] == 15 ||
			map.map[cy][cx] == 14 || map.map[cy][cx] == 15){
			return true;
		}
		return false;
	}
	
	private function onWall():Bool{
		if ( map.map[cy][cx] == 1 ){
			return true;
		}
		return false;
	}
	
	private function onFinish():Bool{
		if ( map.map[cy + 1][cx] == 16 || map.map[cy + 1][cx] == 17 ||
			map.map[cy][cx] == 16 || map.map[cy][cx] == 17){
			return true;
		}
		return false;
	}
	
	private function checkDied(){
		if (time < 0){
			isDied = true;
			diedReason = Constant.getMessage(Constant.DIED_WATER);
		}
	}

}