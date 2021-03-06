package net.mkv25.base.ui;

import motion.Actuate;
import net.mkv25.base.core.Text;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormatAlign;

class ButtonUI extends BaseUI 
{
	private static inline var DEFAULT_ASSET_PREFIX:String = "img/button/button_select";
	
	var bitmap:Bitmap;
	var textField:TextField;
	var assetPrefix:String;
	
	var waitingOnActivation:Bool;
	var action:Dynamic->Void;
	
	public function new() 
	{
		super();
		
		bitmap = new Bitmap();
		textField = Text.makeTextField("fonts/hooge-0665.ttf", 24, 0x333333, TextFormatAlign.CENTER);
		assetPrefix = DEFAULT_ASSET_PREFIX;
		
		waitingOnActivation = false;
		action = null;
		
		artwork.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		artwork.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	public function setup(label:String, action:Dynamic->Void, assetPrefix:String=DEFAULT_ASSET_PREFIX):Void
	{
		this.action = action;
		this.assetPrefix = assetPrefix;
		
		artwork.addChild(bitmap);
		artwork.addChild(textField);
		
		textField.text = label;		
		updateLabelSize();
		
		upState();
	}
	
	function updateLabelSize()
	{
		if (bitmap == null)
		{
			textField.width = 100;
			textField.height = 30;
		}
		else
		{
			textField.width = bitmap.width;
			textField.height = bitmap.height;
		}
		center(textField);
	}
	
	function activate():Void {
		if (waitingOnActivation)
			return;
			
		if (action == null)
			return;
		
		waitingOnActivation = true;
		Actuate.timer(0.1).onComplete(onActivationComplete);
	}
	
	function onActivationComplete():Void {
		action(this);
		waitingOnActivation = false;
	}
	
	function upState()
	{
		#if mobile
		
		overState();
		return;
		
		#else
		
		bitmap.bitmapData = Assets.getBitmapData(assetPrefix + "_up.png");
		center(bitmap);
		updateLabelSize();
		
		#end
	}
	
	function overState()
	{
		bitmap.bitmapData = Assets.getBitmapData(assetPrefix + "_over.png");
		center(bitmap);
		updateLabelSize();
	}
	
	function downState()
	{
		bitmap.bitmapData = Assets.getBitmapData(assetPrefix + "_down.png");
		center(bitmap);
		updateLabelSize();
	}
	
	function onMouseOver(e)
	{
		overState();
	}
	
	function onMouseOut(e)
	{
		upState();
	}
	
	function onMouseDown(e)
	{
		downState();
		
		activate();
	}
	
	function onMouseUp(e)
	{
		overState();
	}
}