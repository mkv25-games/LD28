package net.mkv25.game.ui;

import motion.Actuate;
import net.mkv25.base.core.Signal;

import net.mkv25.base.ui.TextUI;

class AnimatedTextUI extends TextUI
{
	public var animationComplete:Signal;
	
	var currentText:String;
	
	public function new() 
	{
		super();
		
		animationComplete = new Signal();
		
		currentText = "";
	}
	
	public function animateText(textToAdd:String):Void
	{
		currentText = "";
		animateAppendText(textToAdd);
	}
	
	public function animateAppendText(textToAdd:String):Void
	{
		if (textToAdd == null || textToAdd.length == 0)
		{
			setText(currentText);
			animationComplete.dispatch(this);
			return;
		}
		
		currentText = currentText + textToAdd.charAt(0);
		setText(currentText + "|");
		textToAdd = textToAdd.substring(1);
		
		Actuate.timer(0.05).onComplete(animateAppendText, [textToAdd]);
	}
	
}