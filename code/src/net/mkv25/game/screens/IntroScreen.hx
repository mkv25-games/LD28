package net.mkv25.game.screens;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Text;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import openfl.Assets;

class IntroScreen extends Screen
{
	var textLD:TextUI;
	var textGameTitle:TextUI;
	var button:ButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/intro_screen.png");
		
		textLD = new TextUI();
		textLD.setup("Ludum Dare 28", 0xFFFFFF).size(300, 50).center(textLD.artwork, cast horizontalCenter, 70);
		
		textGameTitle = new TextUI();
		textGameTitle.setup("You Only Get One...", 0xFFFFFF).size(400, 50).center(textGameTitle.artwork, cast horizontalCenter, 140);
		
		button = new ButtonUI();
		button.setup("Begin", onBeginAction);
		button.move(horizontalCenter, verticalCenter + 100);
		
		artwork.addChild(button.artwork);
		artwork.addChild(textLD.artwork);
		artwork.addChild(textGameTitle.artwork);
	}
	
	override public function show():Void 
	{
		super.show();
		
		Actuate.apply(textLD.artwork, { alpha: 0.0 } );
		Actuate.apply(textGameTitle.artwork, { alpha: 0.0 } );
		Actuate.apply(button.artwork, { alpha: 0.0 } );
		
		Actuate.tween(textLD.artwork, 0.8, { alpha: 1.0 } ).delay(1.5);
		Actuate.tween(textGameTitle.artwork, 0.8, { alpha: 1.0 } ).delay(3.0);
		Actuate.tween(button.artwork, 0.8, { alpha: 1.0 } ).delay(4.5);
	}
	
	function onBeginAction(model:ButtonUI)
	{
		EventBus.requestNextScreen.dispatch(this);
	}
}