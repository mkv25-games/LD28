package net.mkv25.game.screens;

import flash.text.TextFormatAlign;
import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.ui.AnimatedTextUI;

class StoryScreen extends Screen
{
	var textTitle:AnimatedTextUI;
	var textScenario:AnimatedTextUI;
	var textInstruction:AnimatedTextUI;
	
	public function new() 
	{
		super();
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
		textInstruction.setup("Instructions", 0xFFFFFF).fontSize(18).align(TextFormatAlign.LEFT).size(600, 40).move(50, Screen.HEIGHT - 40);
		
		artwork.addChild(textTitle.artwork);
		artwork.addChild(textScenario.artwork);
		artwork.addChild(textInstruction.artwork);
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
		textInstruction.animateText("Press LEFT and RIGHT to Move");
	}
}