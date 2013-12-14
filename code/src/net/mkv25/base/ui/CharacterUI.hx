package net.mkv25.base.ui;
import net.mkv25.base.core.AnimationFrameCache;
import net.mkv25.base.core.ImageRegion;

class CharacterUI extends AnimationUI
{
	var id:String;
	var spritePath:String;
	
	var framesStanding:Array<Int>;
	var framesWalk:Array<Int>;
	var pixelsPerPixel:Int = 4;

	public function new() 
	{
		super();
	}
	
	public function setup(id:String, spritePath:String)
	{
		this.id = id;
		this.spritePath = spritePath;
		
		framesStanding = [0];
		framesWalk = [1, 2, 3, 4];
		
		artwork.scaleX = artwork.scaleY = pixelsPerPixel;
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
	}
	
	public function walkRight()
	{
		setFrames(framesWalk);
		artwork.scaleX = 1 * pixelsPerPixel;
		play();
	}
	
	public function walkLeft()
	{
		setFrames(framesWalk);
		artwork.scaleX = -1 * pixelsPerPixel;
		
		play();
	}
	
	public function faceRight()
	{
		setFrames(framesStanding);
		artwork.scaleX = 1 * pixelsPerPixel;
		stop();
	}
	
	public function faceLeft()
	{
		setFrames(framesStanding);
		artwork.scaleX = -1 * pixelsPerPixel;
		stop();
	}
}