package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author umhr
	 */
	public class Sheet extends Sprite 
	{
		private var _photo:Bitmap;
		//private var _bitmap:Bitmap;
		private var _textField:TextField = new TextField();
		private var _captionBG:Shape = new Shape();
		public function Sheet(index:int) 
		{
			_photo = new Bitmap(DataManager.getInstance().getBitmapData(index), "auto", true);
			var textFormat:TextFormat = new TextFormat("_sans", 36, 0xFFFFFF);
			textFormat.leading = 6;
			textFormat.leftMargin = 32;
			textFormat.rightMargin = 32;
			_textField.defaultTextFormat = textFormat;
			_textField.text = DataManager.getInstance().getCaption(index);
			_textField.wordWrap = true;
			_textField.selectable = false;
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
			
			addChild(_photo);
			addChild(_captionBG);
			addChild(_textField);
			//addChild(_bitmap);
			reSize();
		}
		
		public function reSize():void {
			var stageWidth:int = stage.stageWidth;
			var stageHeight:int = stage.stageHeight;
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, stageWidth, stageHeight);
			graphics.endFill();
			
			_photo.scaleX = _photo.scaleY = Math.min(stageWidth / _photo.width, stageHeight / _photo.height);
			_photo.x = (stageWidth - _photo.width) * 0.5;
			_photo.y = (stageHeight - _photo.height) * 0.5;
			
			var tani:int = stageHeight / 25;
			var textFormat:TextFormat = _textField.defaultTextFormat;
			textFormat.size = tani;
			_textField.setTextFormat(textFormat);
			_textField.width = stageWidth;
			_textField.height = stageHeight;
			_textField.height = _textField.textHeight + tani * 0.5;
			_textField.y = stageHeight - _textField.height - tani * 0.2;
			
			_captionBG.graphics.clear();
			_captionBG.graphics.beginFill(0, 0.4);
			_captionBG.graphics.drawRect(0, _textField.y - tani * 0.2, _textField.width, _textField.height + tani * 0.5);
			_captionBG.graphics.endFill();
			
			//_bitmap = new Bitmap();
			//_bitmap.bitmapData = new BitmapData(stageWidth, stageHeight, false, 0xFF000000);
			//_bitmap.bitmapData.draw(this);
		}
	}
	
}