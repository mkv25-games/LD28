package net.mkv25.game.ui;

import flash.events.KeyboardEvent;
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
	var collidingWith:EntityUI;
	
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
			if (collidingWith == null)
			{
				collidingWith = entity;
				collideWith(entity);
			}
			
			return true;
		}
		
		if (collidingWith == entity)
		{
			collidingWith = null;
			uncollideWith(entity);
		}
		
		return false;
	}
	
	public function interactWith(player:CharacterUI):Bool
	{
		player.claim(this);
		
		return true;
	}
	
	public function collideWith(entity:EntityUI)
	{
		
	}
	
	public function uncollideWith(entity:EntityUI)
	{
		
	}
	
	public function handleKeyAction(event:KeyboardEvent):Void 
	{
		
	}
}