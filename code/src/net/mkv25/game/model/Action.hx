package net.mkv25.game.model;
import net.mkv25.base.core.Signal;

class Action
{
	public static var SAY_HELLO = new Action("Say hello");
	public static var RUN_AWAY = new Action("Run away");
	public static var OFFER_ROSE = new Action("Offer rose");
	
	public var name:String;
	public var signal:Signal;

	public function new(name:String) 
	{
		this.name = name;
		signal = new Signal();
	}
	
}