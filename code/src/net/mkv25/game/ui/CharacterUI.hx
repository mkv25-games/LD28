package net.mkv25.game.ui;

import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Signal;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.CharacterAnimationUI;
import net.mkv25.game.event.EventBus;

class CharacterUI extends EntityUI
{
	public static inline var GREETING:String = "Hey there";
	
	var animation:CharacterAnimationUI;
	var textTalk:AnimatedTextUI;
	
	var framesStanding:Array<Int>;
	var framesWalking:Array<Int>;
	var framesTalking:Array<Int>;
	var framesBlushing:Array<Int>;
	
	var motionX:Float;
	var targetX:Float;
	var targetEntity:EntityUI;
	
	var inventory:Array<EntityUI>;
	
	var targetReached:Signal;
	
	public function new() 
	{
		super();
		
		animation = new CharacterAnimationUI();
		textTalk = new AnimatedTextUI();
		
		framesStanding = [0];
		framesWalking = [1, 2, 3, 4];
		framesTalking = [5, 6, 7];
		framesBlushing = [8, 9];
		
		motionX = 0;
		targetX = 0;
		targetEntity = null;
		
		inventory = new Array<EntityUI>();
		
		targetReached = new Signal();
	}
	
	public function setup(id:String, spriteSheet:String, name:String)
	{
		this.name = name;
		
		animation.setup(id, spriteSheet);		
		animation.artwork.scaleX = animation.artwork.scaleY = pixelsPerPixel;
		animation.drawFirst();
		animation.center();
		animation.frameDrawn.add(onFrameDrawn);
		
		textTalk.setup("", 0xFFFFFF).fontSize(18).size(600, 40).move( -300, -80);
		textTalk.setCursor("");
		
		targetReached.add(onTargetReached);
		
		artwork.addChild(animation.artwork);
		artwork.addChild(textTalk.artwork);
	}
	
	function onFrameDrawn(model:CharacterAnimationUI):Void
	{
		processMotion();
	}
	
	function moveTowardsTarget(x:Float)
	{
		targetX = x;
		
		if(Math.round(artwork.x / 2) == Math.round(targetX / 2))
		{
			targetReached.dispatch(this);
		}
		else if (artwork.x > targetX)
		{
			walkLeft();
		}
		else if(artwork.x < targetX)
		{
			walkRight();
		}
		else 
		{
			throw "Not on any map of the universe that we know about.";
		}
	}
	
	function onTargetReached(model:CharacterUI)
	{
		if (targetEntity != null)
		{
			if (artwork.x > targetEntity.artwork.x)
			{
				faceLeft();
			}
			else
			{
				faceRight();
			}
		}
	}
	
	function processMotion()
	{
		if (motionX != 0)
		{
			artwork.x = artwork.x + motionX * pixelsPerPixel;
		}
			
		// constrain position
		artwork.x = Math.max(20, artwork.x);
		artwork.x = Math.min(Screen.WIDTH - 20, artwork.x);
		
		// check for target
		if (targetX != -1 && Math.round(artwork.x / 2) == Math.round(targetX / 2))
		{
			targetX = -1;
			targetReached.dispatch(this);
		}
	}
	
	public function walkRight()
	{
		animation.setFrames(framesWalking);
		artwork.scaleX = 1;
		if (motionX < 0)
			return faceRight();
		else
			motionX = 0.4;
		animation.play();
	}
	
	public function walkLeft()
	{
		animation.setFrames(framesWalking);
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
		
		inventory.push(entity);
	}
	
	override public function interactWith(player:CharacterUI):Bool
	{
		sayTo(player, GREETING);
		
		player.walkToAndFace(artwork.x - 40, this);
		
		return true;
	}
	
	override public function collideWith(entity:EntityUI)
	{
		animation.setFrames(framesBlushing);
		animation.play();
		trace("collide with " + entity.name);
	}
	
	override public function uncollideWith(entity:EntityUI)
	{
		textTalk.animateText("");
		faceRight();
		trace("uncollide with " + entity.name);
	}
	
	public function setDefaultTarget(x:Float)
	{
		targetX = x;
	}
	
	function sayTo(entity:CharacterUI, words:String)
	{
		textTalk.animateText("");
		textTalk.animateText(words);
		animation.setFrames(framesTalking);
		animation.play();
	}
	
	function walkToAndFace(x:Float, entity:EntityUI)
	{
		targetEntity = entity;
		stopWalking();
		moveTowardsTarget(x);
	}
	
}