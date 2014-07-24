package  
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class PostData 
	{
		public var date:Date = new Date();
		public var caption:String = "";
		public var url:String = "";
		public var bitmapData:BitmapData;
		public function PostData() 
		{
			
		}
		
		public function fromXML(xml:XML):PostData {
			//trace(xml);
			//<post id="92236703775" url="http://umhr.tumblr.com/post/92236703775" url-with-slug="http://umhr.tumblr.com/post/92236703775/10-30" type="photo" date-gmt="2014-07-19 13:31:59 GMT" date="Sat, 19 Jul 2014 22:31:59" unix-timestamp="1405776719" format="html" reblog-key="frk6I4yw" slug="10-30" width="640" height="640">
			//<photo-caption>&lt;p&gt;総持寺の盆踊り。客層は10～30代でアンコールも。まるで野外フェス&lt;/p&gt;</photo-caption>
			//<photo-link-url>http://instagram.com/p/qomis9lBLa/</photo-link-url>
			//<photo-url max-width="1280">http://38.media.tumblr.com/64c1e2bcd432f697cec3b556786ef382/tumblr_n8yo9fx08F1qzm8kto1_1280.jpg</photo-url>
			
			var youbiList:Array = ["日", "月", "火", "水", "木", "金", "土"];
			date.setTime(int(xml["@unix-timestamp"]) * 1000);
			var dateString:String = date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日（"+youbiList[date.getDay()]+"）";
			caption = String(xml["photo-caption"]);
			caption = dateString + ":" + characterReference(caption);
			
			var n:int = xml["photo-url"].length();
			for (var i:int = 0; i < n; i++) 
			{
				if (int(xml["photo-url"][i]["@max-width"]) <= 1280) {
					url = String(xml["photo-url"][i]);
					break;
				}
			}
			
			return this;
		}
		private function characterReference(text:String):String {
			text = text.replace(/<p>|<\/p>/g, '').replace(/&quot;/g, '"').replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&nbsp;/g, " ").replace(/&copy;/g, "©");
			return text;
		}
		
		public function clone():PostData {
			var result:PostData = new PostData();
			
			return result;
		}
		
		public function toString():String {
			var result:String = "PostData:{";
			
			result += "}";
			return result;
		}
		
	}
	
}