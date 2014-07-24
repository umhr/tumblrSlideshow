package  
{
	
	import a24.tween.Tween24;
	import adobe.utils.CustomActions;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
	{
		private var sheetList:Vector.<Sheet> = new Vector.<Sheet>();
		private var _photoCanvas:Sprite = new Sprite();
		private var _navigaterBar:NavigaterBar = new NavigaterBar();
		public function Canvas() 
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
			addChild(_photoCanvas);
			addChild(_navigaterBar);
			_navigaterBar.addEventListener(Event.CHANGE, navigaterBar_change);
			_navigaterBar.addEventListener(Event.CLOSE, navigaterBar_close);
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
			
			doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
			start();
		}
		
		private function navigaterBar_close(e:Event):void 
		{
			_navigaterBar.count = -100;
		}
		
		private function navigaterBar_change(e:Event):void 
		{
			trace(DataManager.getInstance().userName);
			_navigaterBar.count = -100;
			reset();
		}
		
		private function stage_enterFrame(e:Event):void 
		{
			if (_navigaterBar.count == 0) {
				Tween24.tween(_navigaterBar, 0.2).y( -_navigaterBar.height).play();
			}else if (_navigaterBar.count == -500){
				Tween24.tween(_navigaterBar, 0.3).y( 0).play();
			}
			_navigaterBar.count ++;
		}
		
		private var _tapDate:Date = new Date();
		private var _tapPoint:Point = new Point();
		private function stage_mouseDown(e:MouseEvent):void 
		{
			var dLength:int = _tapPoint.subtract(new Point(mouseX, mouseY)).length;
			var dTime:int = new Date().time-_tapDate.time;
			if (dTime < 1000 && dLength < 50) {
				_navigaterBar.count = -501;
			}
			_tapDate = new Date();
			_tapPoint = new Point(mouseX, mouseY);
		}
		
		private function start():void {
			DataManager.getInstance().addEventListener(Event.COMPLETE, onComp);
			DataManager.getInstance().addEventListener(IOErrorEvent.IO_ERROR, ioError);
			DataManager.getInstance().start();
			
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat("_sans", 24, 0xFFFFFF);
			textField.defaultTextFormat = textFormat;
			textField.text = "有効なアカウントを入力してください。";
			textField.selectable = false;
			textField.width = stage.stageWidth;
			_photoCanvas.addChild(textField);
		}
		
		private function onComp(e:Event):void 
		{
			DataManager.getInstance().removeEventListener(Event.COMPLETE, onComp);
			DataManager.getInstance().addEventListener("update", onUpdate);
			
			_count = 0;
			sheetList.length = 0;
			var n:int = DataManager.getInstance().length;
			for (var i:int = 0; i < n; i++) 
			{
				sheetList[i] = new Sheet(i);
			}
			
			while (_photoCanvas.numChildren > 0) {
				_photoCanvas.removeChildAt(0);
			}
			if (n == 0) {
				return;
			}
			
			var nowSheet:Sheet = sheetList[0];
			nowSheet.alpha = 0;
			_photoCanvas.addChild(nowSheet);
			Tween24.tween(nowSheet, 1).alpha(1).play();
			
			_timer.reset();
			_timer.addEventListener(TimerEvent.TIMER, timer_timer);
			_timer.start();
		}
		
		private function reset():void {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0);
			shape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			shape.graphics.endFill();
			shape.alpha = 0;
			_photoCanvas.addChild(shape);
			Tween24.tween(shape, 1).alpha(1).play();
			_timer.reset();
			start();
			
		}
		
		private function onUpdate(e:Event):void 
		{
			reset();
		}
		
		private var _count:int;
		private var _timer:Timer = new Timer(1000 * 10);
		private function timer_timer(e:TimerEvent):void 
		{
			tween();
		}
		
		private function tween():void {
			if (_count == DataManager.getInstance().length-1) {
				DataManager.getInstance().checkUpdate();
			}
			
			var now:Sheet = sheetList[_count];
			var next:Sheet = sheetList[(_count + 1) % DataManager.getInstance().length];
			
			Tween24.serial(
				Tween24.prop(next).alpha(1).scaleXY(1, 1),
				Tween24.addChildAt(_photoCanvas, next, 0),
				Tween24.tween(now, 1).alpha(0),
				Tween24.removeChild(now)
			).play();
			
			_count ++;
			_count = _count % DataManager.getInstance().length;
		}
	}
	
}