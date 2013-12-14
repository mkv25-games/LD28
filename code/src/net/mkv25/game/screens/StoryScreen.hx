package net.mkv25.game.screens;

import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.TextUI;

class StoryScreen extends Screen
{
	var textTitle:TextUI;
	
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
	
}