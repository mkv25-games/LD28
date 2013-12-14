package net.mkv25.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.ScreenController;
import net.mkv25.base.ui.DebugUI;
import net.mkv25.game.model.GameModel;
import net.mkv25.game.screens.IntroScreen;
import net.mkv25.game.screens.StoryScreen;

class Index
{
	private static var failsafe:Bool = false;
	
	// models
	public static var gameModel:GameModel;
	
	// controllers
	public static var screenController:ScreenController;
	public static var debug:DebugUI;
	
	// screens
	public static var introScreen:Screen;
	public static var storyScreen:Screen;
	
	// play time
	public static function setup():Void
	{
		// prevent method from being executed more then once
		if (failsafe)
		{
			throw "The glass has already been broken.";
		}
		failsafe = true;
		
		// models
		gameModel = new GameModel();
		
		// controllers
		screenController = new ScreenController();
		
		// screens
		introScreen = new IntroScreen();
		storyScreen = new StoryScreen();
		
		// debugging
		#if debug
			debug = new DebugUI(screenController);
		#end
	}
}