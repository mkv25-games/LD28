package net.mkv25.game.event;

import net.mkv25.base.core.Signal;

class EventBus 
{
	// general screen navigation
	public static var requestNextScreen = new Signal();
	public static var requestLastScreen = new Signal();
	
	// screen specific
	public static var displayInstruction = new Signal();
	
	public function new() 
	{
		
	}
	
}