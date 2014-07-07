package utils
{
	import flash.display.DisplayObjectContainer;
	import flash.net.LocalConnection;
	
	/**
	 * 公共函数【禁止实例化】
	 */
	public class $ extends BaseUtils
	{
		public function $()
		{
			throw new Error("$ can not be Instantiated!");
		}
		
		/**
		 * 判断文本是否为空引用或者为空字符串 
		 * @param text
		 * @return 
		 * 
		 */		
		public static function isNullOrEmpty(text:String):Boolean
		{
			return text == null || text == "";
		}
		
		/**
		 * 判断对象是否为空引用
		 * @param object
		 * @return 
		 * 
		 */		
		public static function isNull(object:Object):Boolean
		{
			return object == null;
		}
		
		/**
		 * 将字符串拆分成数组，并且去除空字符串元素
		 * @param text
		 * @param splitChar
		 * @return 
		 * 
		 */
		public static function split(text:String, splitChar:String = ","):Array
		{
			if(isNullOrEmpty(text)) return [];
			
			var textList:Array = text.split(splitChar);
			
			var resultList:Array = [];
			for each(var itemText:String in textList){
				if(!isNullOrEmpty(itemText)){
					resultList.push(itemText);
				}
			}	
			return resultList;
		}
		
		/**
		 * 清空子元素 
		 * @param displayObjectContainer
		 * 
		 */		
		public static function clear(displayObjectContainer:DisplayObjectContainer):void
		{
			if($.isNull(displayObjectContainer)) return;
			
			while(displayObjectContainer.numChildren > 0){
				delete displayObjectContainer.removeChildAt(0);
			}
		}
		
		/**
		 * 强制执行垃圾回收 
		 * 
		 */		
		public static function gc():void
		{
			try 
			{
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			} 
			catch (exception:Error) {}
		}
	}
}