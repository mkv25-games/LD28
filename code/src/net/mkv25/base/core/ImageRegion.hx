package net.mkv25.base.core;

import openfl.Assets;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class ImageRegion
{
	public static function getImageRegion(source:String, x:Int, y:Int, width:Int, height:Int):BitmapData
	{		
		return ImageRegion.getImage(source, new Rectangle(x, y, width, height));
	}
	
	public static function getImageFrame(source:String, frame:Int, width:Int, height:Int):BitmapData
	{
		var asset:BitmapData = Assets.getBitmapData(source);
		var columns:Int = Math.round(asset.width / width);
		
		var col = frame % columns;
		var row = Math.floor(frame / columns);
		
		return ImageRegion.getImageRegion(source, col * width, row * height, width, height);
	}
	
	private static function getImage(source:String, rectangle:Rectangle, outputOffset:Point = null):BitmapData
	{		
		var output:BitmapData = new BitmapData(cast rectangle.width, cast rectangle.height);
		var source:BitmapData = Assets.getBitmapData(source);
		if (outputOffset == null) outputOffset = new Point();
		
		output.copyPixels(source, rectangle, outputOffset);
		
		return output;
	}
}