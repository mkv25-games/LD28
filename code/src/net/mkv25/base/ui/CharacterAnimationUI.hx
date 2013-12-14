package net.mkv25.base.ui;
import net.mkv25.base.core.AnimationFrameCache;
import net.mkv25.base.core.ImageRegion;
import net.mkv25.base.core.Signal;

class CharacterAnimationUI extends AnimationUI
{
	public var frameDrawn:Signal;
	
	var id:String;
	var spritePath:String;

	public function new() 
	{
		super();
		
		frameDrawn = new Signal();
	}
	
	public function setup(id:String, spritePath:String)
	{
		this.id = id;
		this.spritePath = spritePath;
	}
	
	override private function draw(frame:Int):Void 
	{
		var frameId = spritePath + "_" + frame;
		var frameBitmap = AnimationFrameCache.singleton.getFrame(frameId);
		if (frameBitmap == null)
		{
			frameBitmap = ImageRegion.getImageFrame(spritePath, frame, 20, 30);
			AnimationFrameCache.singleton.setFrame(frameId, frameBitmap);
		}
		
		artwork.bitmapData = frameBitmap;
		
		frameDrawn.dispatch(this);
	}
}