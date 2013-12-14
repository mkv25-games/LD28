package net.mkv25.game.ui;

import motion.Actuate;
import motion.actuators.GenericActuator.IGenericActuator;
import net.mkv25.base.core.Signal;

import net.mkv25.base.ui.TextUI;

class AnimatedTextUI extends TextUI
{
	public var animationComplete:Signal;
	
	var currentText:String;
	var currentTimer:IGenericActuator;
	
	public function new() 
	{
		super();
		
		animationComplete = new Signal();
		
		currentText = "";
	}
	
	public function animateText(textToAdd:String):Void
	{
		if (currentText == textToAdd)
		{
			return;
		}
		
		if (currentTimer != null)
		{
			currentTimer.onComplete(null);
		}
		
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
		
		currentTimer = Actuate.timer(0.05).onComplete(animateAppendText, [textToAdd]);
	}
	
}