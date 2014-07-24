package  
{
	
	import a24.tween.Tween24;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author umhr
	 */
	public class NavigaterBar extends Sprite 
	{
		public var input:TextField = new TextField();
		public var count:int = -300;
		public function NavigaterBar() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat("_sans", 54, 0xFFFFFF);
			textField.defaultTextFormat = textFormat;
			textField.text = ".tumblr.com";
			textField.selectable = false;
			textField.width = 330;
			textField.height = 70;
			textField.x = stage.stageWidth * 0.5;
			textField.y = 30;
			addChild(textField);
			
			var textFormat2:TextFormat = new TextFormat("_sans", 54, 0xFFFFFF);
			textFormat2.align = "right";
			input.defaultTextFormat = textFormat2;
			input.type = "input";
			input.text = DataManager.getInstance().userName;
			input.width = 400;
			input.height = 70;
			input.x = textField.x - input.width;
			input.y = 30;
			input.border = true;
			input.borderColor = 0x999999;
			input.addEventListener(Event.CHANGE, input_change);
			input.addEventListener(MouseEvent.MOUSE_DOWN, input_mouseDown);
			addChild(input);
			
			graphics.clear();
			graphics.beginFill(0x333333, 0.7);
			graphics.drawRect(0, 0, stage.stageWidth, textField.y + textField.height + 24);
			graphics.endFill();
			
			var btn:Sprite = new Sprite();
			btn.graphics.beginFill(0x999999, 1);
			btn.graphics.drawRect(0, 0, 150, 70);
			btn.graphics.endFill();
			btn.graphics.lineStyle(2,0,0.5);
			btn.graphics.drawRect(4, 4, 150 - 8, 70 - 8);
			btn.graphics.endFill();
			btn.x = textField.x +textField.width;
			btn.y = 30;
			btn.addEventListener(MouseEvent.MOUSE_DOWN, btn_mouseDown);
			addChild(btn);
			
			var textFormat3:TextFormat = new TextFormat("_sans", 42, 0xFFFFFF);
			textFormat3.align = "center";
			var btnLabel:TextField = new TextField();
			btnLabel.defaultTextFormat = textFormat3;
			btnLabel.text = "設定";
			btnLabel.selectable = false;
			btnLabel.mouseEnabled = false;
			btnLabel.width = 150;
			btnLabel.height = 70;
			btnLabel.x = btn.x;
			btnLabel.y = btn.y + 9;
			addChild(btnLabel);
			
			
			
		}
		
		private function input_mouseDown(e:MouseEvent):void 
		{
			count = -400;
		}
		
		private function input_change(e:Event):void 
		{
			count = -300;
		}
		
		private function btn_mouseDown(e:MouseEvent):void 
		{
			if (DataManager.getInstance().userName != input.text) {
				DataManager.getInstance().userName = input.text;
				dispatchEvent(new Event(Event.CHANGE));
			}else {
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
	}
	
}