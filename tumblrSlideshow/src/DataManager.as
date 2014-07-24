package  
{
	import br.com.stimuli.loading.BulkLoader;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	/**
	 * ...
	 * @author umhr
	 */
	public class DataManager extends EventDispatcher
	{
		private static var _instance:DataManager;
		public function DataManager(block:Block){init();};
		public static function getInstance():DataManager{
			if ( _instance == null ) {_instance = new DataManager(new Block());};
			return _instance;
		}
		
		private var _bulkLoader:BulkLoader = new BulkLoader("theOne");
		private var _postDataList:Vector.<PostData> = new Vector.<PostData>();
		public var userName:String = "umhr";
		private var _postsTotal:int;
		private function init():void
		{
			var name:String = getSharedObject();
			if (name) {
				userName = name;
			}
			
		}
		
		public function start():void {
			_postDataList.length = 0;
			load(0, 20);
		}
		private function load(start:int, num:int):void {
			_bulkLoader.addEventListener("complete", onComp);
			_bulkLoader.addEventListener(BulkLoader.ERROR, bulkLoader_error);
			_bulkLoader.add("http://" + userName+".tumblr.com/api/read/?filter=text&type=photo&start=" + start + "&num=" + num, { id:"apiXML", type:BulkLoader.TYPE_XML } );
			_bulkLoader.start();
		}
		
		private function bulkLoader_error(e:Event):void 
		{
			_bulkLoader.removeAll();
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			_bulkLoader.removeEventListener("complete", onComp);
			_bulkLoader.removeEventListener(BulkLoader.ERROR, bulkLoader_error);
		}
		
		private function onComp(e:Event):void 
		{
			_bulkLoader.removeEventListener("complete", onComp);
			_bulkLoader.removeEventListener(BulkLoader.ERROR, bulkLoader_error);
			
			var apiXML:XML = _bulkLoader.getXML("apiXML", true);
			var n:int = apiXML.posts.post.length();
			for (var i:int = 0; i < n; i++) 
			{
				_postDataList.push(new PostData().fromXML(apiXML.posts.post[i]));
			}
			
			var total:int = int(apiXML.posts["@total"]);
			if (int(apiXML.posts["@start"]) == 0 && total >= 30 && n != 0) {
				var start:int = n + Math.random() * (total - 10 - n);
				load(start, 10);
			}else if (int(apiXML.posts["@start"]) == 0 && n == 0){
					if (_postsTotal != total) {
						dispatchEvent(new Event("update"));
					}
			}else {
				loadImages();
			}
			
			_postsTotal = total;
		}
		
		public function checkUpdate():void {
			load(0, 0);
		}
		
		private function loadImages():void {
			var n:int = _postDataList.length;
			for (var i:int = 0; i < n; i++) 
			{
				var lc:LoaderContext = new LoaderContext();
				lc.checkPolicyFile = true;
				_bulkLoader.add(_postDataList[i].url, { id:"img" + i, type:BulkLoader.TYPE_IMAGE,context:lc } );
			}
			_bulkLoader.addEventListener("complete", onImgComp);
			_bulkLoader.start();
		}
		
		private function onImgComp(e:Event):void 
		{
			_bulkLoader.removeEventListener("complete", onImgComp);
			var n:int = _postDataList.length;
			for (var i:int = 0; i < n; i++) 
			{
				_postDataList[i].bitmapData = _bulkLoader.getBitmapData("img" + i, true);
			}
			dispatchEvent(new Event(Event.COMPLETE));
			if (n > 0) {
				setSharedObject();
			}
		}
		
		public function getBitmapData(index:int):BitmapData {
			return _postDataList[index].bitmapData;
		}
		public function getCaption(index:int):String {
			return _postDataList[index].caption;
		}
		public function get length():int {
			return _postDataList.length;
		}
		
		public function getSharedObject():String {
			var result:String;
			var so:SharedObject = SharedObject.getLocal("tumblrSlideshow");
			if (so) {
				var obj:Object = so.data;
				if (obj.userName && obj.userName.length > 0) {
					result = obj.userName;
					trace(obj.userName);
				}
			}
			return result;
		}
		public function setSharedObject():void {
			var so:SharedObject = SharedObject.getLocal("tumblrSlideshow");
			if(so){
				var obj : Object = so.data;
				obj.userName = userName;
			}			
		}
	}
	
}
class Block { };