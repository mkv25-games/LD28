package net.mkv25.game.ui;
import flash.events.KeyboardEvent;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import motion.Actuate;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.model.Action;

class DecisionUI extends EntityUI
{
	var menuSelection:BitmapUI;
	var textOptions:Array<AnimatedTextUI>;
	
	var selection:Int;
	var currentOptions:Array<Action>;
	
	public function new() 
	{
		super();
		
		menuSelection = new BitmapUI();
		textOptions = new Array<AnimatedTextUI>();
		
		selection = 0;
	}	
	
	public function setup()
	{
		menuSelection.setup("img/menu_selection.png");
		menuSelection.move(10, 35);
		
		for (i in 0...5)
		{
			var text = new AnimatedTextUI();
			text.setup("Option " + i, 0xFFFFFF).fontSize(18).align(TextFormatAlign.LEFT).size(180, 30).move(30, 10 + 40 * i);
			
			textOptions.push(text);
			artwork.addChild(text.artwork);
		}
		
		artwork.addChild(menuSelection.artwork);
	}
	
	public function display(options:Array<Action>)
	{
		this.currentOptions = options;
		
		var i:Int = 0;
		for (text in textOptions)
		{
			if (i < options.length)
			{
				var option = options[i];
				text.show();
				text.animateText("");
				Actuate.timer(0.1 * i).onComplete(text.animateText, [option.name]);
			}
			else
			{
				text.hide();
			}
			i++;
		}
		
		var graphics = artwork.graphics;
		graphics.clear();
		graphics.beginFill(0x000000, 0.5);
		graphics.drawRect(0, 0, 220, 10 + 40 * options.length);
		
		selection = 0;
		updateSelection();
	}
	
	function updateSelection()
	{
		if (selection < 0)
		{
			selection = currentOptions.length - 1;
		}
		else
		{
			selection = selection % currentOptions.length;
		}
		
		menuSelection.move(15, 25 + 40 * selection);
	}
	
	function makeSelection()
	{
		var selectedItem = currentOptions[selection];
		EventBus.menuOptionSelected.dispatch(selectedItem);
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void 
	{
		if (event.keyCode == Keyboard.UP)
		{
			selection--;
			updateSelection();
		}
		
		if (event.keyCode == Keyboard.DOWN)
		{
			selection++;
			updateSelection();
		}
		
		if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.E)
		{
			makeSelection();
		}
	}
}