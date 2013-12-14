package net.mkv25.game.model;

import net.mkv25.base.core.CoreModel;

class GameModel extends CoreModel
{
	public var flags:GameFlagsModel;
	
	public function new() 
	{
		super();
		
		flags = new GameFlagsModel();
	}
	
}