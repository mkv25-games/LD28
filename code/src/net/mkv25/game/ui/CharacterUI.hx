package net.mkv25.game.ui;

import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.CharacterAnimationUI;
import net.mkv25.game.event.EventBus;

class CharacterUI extends EntityUI
{
	var animation:CharacterAnimationUI;
	
	var framesStanding:Array<Int>;
	var framesWalk:Array<Int>;
	
	var motionX:Float = 0;
	
	public function new() 
	{
		super();
		
		framesStanding = [0];
		framesWalk = [1, 2, 3, 4];
	}
	
	public function setup()
	{
		animation = new CharacterAnimationUI();
		animation.setup("red", "img/animations/character_red_male.png");		
		animation.artwork.scaleX = animation.artwork.scaleY = pixelsPerPixel;
		animation.drawFirst();
		animation.center();
		
		animation.frameDrawn.add(onFrameDrawn);
		artwork.addChild(animation.artwork);
	}
	
	function onFrameDrawn(model:CharacterAnimationUI):Void
	{
		if (motionX != 0)
		{
			artwork.x = artwork.x + motionX * pixelsPerPixel;
		}
			
		// constrain position
		artwork.x = Math.max(20, artwork.x);
		artwork.x = Math.min(Screen.WIDTH - 20, artwork.x);
	}
	
	public function walkRight()
	{
		animation.setFrames(framesWalk);
		artwork.scaleX = 1;
		if (motionX < 0)
			return faceRight();
		else
			motionX = 0.4;
		animation.play();
	}
	
	public function walkLeft()
	{
		animation.setFrames(framesWalk);
		artwork.scaleX = -1;
		if (motionX > 0)
			return faceLeft();
		else
			motionX = -0.4;
		
		animation.play();
	}
	
	public function faceRight()
	{
		animation.setFrames(framesStanding);
		artwork.scaleX = 1;
		motionX = 0;
		animation.drawFirst();
	}
	
	public function faceLeft()
	{
		animation.setFrames(framesStanding);
		artwork.scaleX = -1;
		motionX = 0;
		animation.drawFirst();
	}
	
	public function stopWalking()
	{
		if (motionX > 0)
		{
			return faceRight();
		}
		else
		{
			return faceLeft();
		}
	}
	
	public function claim(entity:EntityUI)
	{
		entity.setIgnoreCollisions(true);
		Actuate.apply(entity.artwork, { x: artwork.x, y: artwork.y } );
		Actuate.tween(entity.artwork, 1.0, { y: artwork.y - 100 } ).onComplete(claimPhase1Complete, [entity]);
	}
	
	function claimPhase1Complete(entity:EntityUI)
	{
		entity.zoomOut().onComplete(claimPhase2Complete, [entity]);
		
		EventBus.displayInstruction.dispatch("Picked up a " + entity.name);
	}
	
	function claimPhase2Complete(entity:EntityUI)
	{
		entity.requestRemove.dispatch(entity);
	}
	
}