package net.mkv25.game.screens;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.AnimationUI;
import net.mkv25.base.ui.CharacterAnimationUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.Index;
import net.mkv25.game.ui.AnimatedTextUI;
import net.mkv25.game.ui.BitmapEntityUI;
import net.mkv25.game.ui.CharacterUI;
import net.mkv25.game.ui.EntityUI;

class StoryScreen extends Screen
{
	var textTitle:AnimatedTextUI;
	var textScenario:AnimatedTextUI;
	var textInstruction:AnimatedTextUI;
	
	var character:CharacterUI;
	var entities:Array<EntityUI>;
	var characterInteractionEntity:EntityUI;
	
	public function new() 
	{
		super();
		
		entities = new Array<EntityUI>();
	}
	
	override private function setup():Void 
	{
		setBackground("img/backgrounds/trees.png");
		background.scaleX = background.scaleY = 4.0;
		
		textTitle = new AnimatedTextUI();
		textTitle.setup("Title", 0xFFFFFF).align(TextFormatAlign.LEFT).size(600, 50).move(50, 50);
		textTitle.animationComplete.add(onTitleAnimationComplete);
		
		textScenario = new AnimatedTextUI();
		textScenario.setup("Scenario", 0xFFFFFF).fontSize(18).align(TextFormatAlign.LEFT).size(600, 80).move(50, 90);
		textScenario.animationComplete.add(onScenarioAnimationComplete);
		
		textInstruction = new AnimatedTextUI();
		textInstruction.setup("Instructions", 0xFFFFFF).fontSize(18).align(TextFormatAlign.LEFT).size(600, 40).move(50, Screen.HEIGHT - 48);
		
		character = new CharacterUI();
		character.setup();
		character.setHitRadius(40);
		character.move(50, Screen.HEIGHT - 130);
		
		var rose = new BitmapEntityUI();
		rose.setup("img/objects/rose.png", "Rose");
		rose.setHitRadius(20);
		rose.move(horizontalCenter, Screen.HEIGHT - 100);
		addEntity(rose);
		
		artwork.addChild(character.artwork);
		artwork.addChild(textTitle.artwork);
		artwork.addChild(textScenario.artwork);
		artwork.addChild(textInstruction.artwork);
		
		EventBus.displayInstruction.add(onDisplayInstruction);
	}
	
	function onDisplayInstruction(message:String)
	{
		textInstruction.animateText(message);
	}
	
	function addEntity(entity:EntityUI)
	{
		entities.push(entity);
		artwork.addChild(entity.artwork);
		entity.requestRemove.add(onEntityRequestRemove);
	}
	
	function onEntityRequestRemove(entity:EntityUI)
	{
		removeEntity(entity);
	}
	
	function removeEntity(entity:EntityUI)
	{
		entities.remove(entity);
		entity.requestRemove.remove(onEntityRequestRemove);
	}
	
	override public function show():Void 
	{
		super.show();
		
		textTitle.setText("");
		textScenario.setText("");
		textInstruction.setText("");
		
		showTitle();
	}
	
	function showTitle()
	{
		textTitle.animateText("Present time, present place...");
	}
	
	function onTitleAnimationComplete(?e)
	{
		Actuate.timer(0.2).onComplete(showScenario);
	}
	
	function showScenario()
	{
		textScenario.animateText("One shot, one life, one chance...    \nOne moment in time...");
	}
	
	function onScenarioAnimationComplete(?e)
	{
		Actuate.timer(0.6).onComplete(showInstructions);
	}
	
	function showInstructions()
	{
		var flags = Index.gameModel.flags;
		
		if (flags.getFlag("Instruction LEFT RIGHT") == false)
		{
			EventBus.displayInstruction.dispatch("Press LEFT and RIGHT to Move");
		}
	}
	
	override public function onEnterFrame(event:Event):Void 
	{
		checkForInteraction();
	}
	
	function checkForInteraction():EntityUI
	{
		var interactionWith:EntityUI = null;
		var flags = Index.gameModel.flags;
		
		for (entity in entities)
		{
			if (character.checkCollisionWith(entity))
			{
				interactionWith = entity;
			}
		}
		
		if (interactionWith != null)
		{
			if (characterInteractionEntity == null)
			{
				characterInteractionEntity = interactionWith;
				EventBus.displayInstruction.dispatch("Press E or ENTER to Interact");
				flags.setFlag("Instruction FIRST INTERACTION");
			}
		}
		else
		{
			if (characterInteractionEntity != null)
			{
				characterInteractionEntity = null;
			}
		}
		
		return interactionWith;
	}
	
	function doInteraction()
	{
		var interaction:EntityUI = checkForInteraction();
		if (interaction != null)
		{
			interaction.interactWith(character);
		}
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void 
	{
		var flags = Index.gameModel.flags;
		
		if (event.keyCode == Keyboard.RIGHT)
		{
			character.walkRight();
			if (flags.getFlag("Instruction LEFT RIGHT") == false)
			{
				EventBus.displayInstruction.dispatch("Press DOWN to Stop");
				flags.setFlag("Instruction LEFT RIGHT");
			}
		}
		
		if (event.keyCode == Keyboard.LEFT)
		{
			character.walkLeft();
			if (flags.getFlag("Instruction LEFT RIGHT") == false)
			{
				EventBus.displayInstruction.dispatch("Press DOWN to Stop");
				flags.setFlag("Instruction LEFT RIGHT");
			}
		}
		
		if (event.keyCode == Keyboard.DOWN)
		{
			character.stopWalking();
			if (flags.getFlag("Instruction DOWN") == false)
			{
				EventBus.displayInstruction.dispatch("");
				flags.setFlag("Instruction DOWN");
			}
		}
		
		if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.E)
		{
			doInteraction();
			if (flags.getFlag("Instruction FIRST INTERACTION"))
			{
				EventBus.displayInstruction.dispatch("");
			}
		}
	}
}