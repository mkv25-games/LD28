package net.mkv25.game.model;

import net.mkv25.base.core.CoreModel;

class GameFlagsModel extends CoreModel
{
	var flags:Map<String,Bool>;
	
	public function new() 
	{
		super();
		
		flags = new Map<String, Bool>();
	}
	
	public function getFlag(name:String):Bool
	{
		if (flags.exists(name))
			return flags.get(name);
		return false;
	}
	
	public function setFlag(name:String, value:Bool = true):Void
	{
		flags.set(name, value);
	}
}