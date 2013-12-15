package net.mkv25.game.screens;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.AnimationUI;
import net.mkv25.base.ui.CharacterAnimationUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.Index;
import net.mkv25.game.model.Action;
import net.mkv25.game.ui.AnimatedTextUI;
import net.mkv25.game.ui.BitmapEntityUI;
import net.mkv25.game.ui.CharacterUI;
import net.mkv25.game.ui.DecisionUI;
import net.mkv25.game.ui.EntityUI;
import openfl.Assets;

class StoryScreen extends Screen
{
	var textTitle:AnimatedTextUI;
	var textScenario:AnimatedTextUI;
	var textInstruction:AnimatedTextUI;
	
	var focus:EntityUI;
	var character:CharacterUI;
	var entities:Array<EntityUI>;
	var characterInteractionEntity:EntityUI;
	var decision:DecisionUI;
	
	var musicChannel:SoundChannel;
	
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
		character.setup("red", "img/animations/character_red_male.png", "Player");
		character.setHitRadius(40);
		character.move(50, Screen.HEIGHT - 130);
		
		var rose = new BitmapEntityUI();
		rose.setup("img/objects/rose.png", "Rose");
		rose.setHitRadius(20);
		rose.move(horizontalCenter, Screen.HEIGHT - 100);
		addEntity(rose);
		
		var girl = new CharacterUI();
		girl.setup("blue", "img/animations/character_blue_female_sitting.png", "Girl");
		girl.setHitRadius(40);
		girl.move(620, Screen.HEIGHT - 142);
		addEntity(girl);
		
		character.setDefaultTarget(girl.artwork.x - 40);
		
		decision = new DecisionUI();
		decision.setup();
		decision.display([Action.RUN_AWAY]);
		decision.move(70, 170);
		decision.hide();
		
		artwork.addChild(character.artwork);
		artwork.addChild(textTitle.artwork);
		artwork.addChild(textScenario.artwork);
		artwork.addChild(textInstruction.artwork);
		artwork.addChild(decision.artwork);
		
		focus = character;
		
		EventBus.displayInstruction.add(onDisplayInstruction);
		EventBus.showMenuOptions.add(onShowMenuOptions);
		EventBus.menuOptionSelected.add(onMenuOptionSeleted);
		EventBus.giveFocusToPlayer.add(onGiveFocusToPlayer);
	}
	
	function onDisplayInstruction(message:String)
	{
		textInstruction.animateText(message);
	}
	
	function onShowMenuOptions(options:Array<Action>)
	{
		focus = decision;
		decision.display(options);
		decision.show();
	}
	
	function onMenuOptionSeleted(option:Action)
	{
		decision.hide();
		focus = character;
		option.signal.dispatch(option);
		character.say("I have chosen to " + option.name.toLowerCase());
	}
	
	function onGiveFocusToPlayer(?e)
	{
		focus = character;
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
		playMusic();
	}
	
	function playMusic()
	{
		if (musicChannel != null)
		{
			musicChannel.stop();
		}
		var music:Sound = Assets.getSound("sounds/intro.mp3");
		musicChannel = music.play(0, 9999);
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
			if (entity.checkCollisionWith(character))
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
		var entity:EntityUI = checkForInteraction();
		if (entity != null)
		{
			entity.interactWith(character);
		}
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void 
	{
		var flags = Index.gameModel.flags;
		var currentFocus = focus;
		
		if (currentFocus != null)
		{
			currentFocus.handleKeyAction(event);
		}
		
		if (currentFocus == character)
		{
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
}