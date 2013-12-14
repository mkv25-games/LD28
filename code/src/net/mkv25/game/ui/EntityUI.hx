package net.mkv25.game.ui;

import flash.geom.Point;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Signal;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.CharacterAnimationUI;

class EntityUI extends BaseUI
{
	public var name:String;
	public var requestRemove:Signal;
	
	var pixelsPerPixel:Int = 4;
	
	var hitRadius:Int = 0;
	var ignoreCollisions:Bool = false;
	
	public function new() 
	{
		super();
		
		name = "";
		requestRemove = new Signal();
	}
	
	public function setHitRadius(radius:Int)
	{
		hitRadius = radius;
		
		#if debug
			var graphics = artwork.graphics;
			graphics.clear();
			graphics.lineStyle(2, 0xFF0000);
			graphics.drawCircle(0, 0, radius);
		#end
	}
	
	public function setIgnoreCollisions(state:Bool):Void
	{
		ignoreCollisions = state;
	}
	
	public function checkCollisionWith(entity:EntityUI):Bool
	{
		if (ignoreCollisions)
		{
			return false;
		}
		
		var difference:Point = new Point(entity.artwork.x - this.artwork.x, entity.artwork.y - this.artwork.y);
		var pointDistance:Float = difference.length;
		var radiusDistance:Float = pointDistance - Math.abs(entity.hitRadius + this.hitRadius);
		if (radiusDistance < 0)
		{
			return true;
		}
		
		return false;
	}
	
	public function interactWith(entity:EntityUI):Bool
	{
		// override, return true for sucessful interaction
		if (Std.is(entity, CharacterUI))
		{
			var character:CharacterUI = cast entity;
			character.claim(this);
		}
		return false;
	}
}