package net.mkv25.game.ui;
import net.mkv25.base.ui.BitmapUI;

class BitmapEntityUI extends EntityUI
{
	var bitmap:BitmapUI;

	public function new() 
	{
		super();
	}
	
	public function setup(asset:String, name:String=""):Void
	{
		bitmap = new BitmapUI();
		bitmap.artwork.scaleX = bitmap.artwork.scaleY = pixelsPerPixel;
		bitmap.setup(asset);
		
		this.name = name;
		
		artwork.addChild(bitmap.artwork);
	}
	
}