package utils
{
	import flash.net.SharedObject;
	
	/**
	 * 本地信息存储【禁止实例化】
	 */
	public class CookieUtils extends BaseUtils
	{
		private static var _hostName:String = "local";
		private static var _sharedObject:SharedObject;
		
		public function CookieUtils()
		{
			throw new Error("CookieUtils can not be Instantiated!");
		}
		
		/**
		 * 初始化 SharedObject
		 * @param hostName
		 * 
		 */		
		public static function init(hostName:String = "local"):void
		{
			_hostName = hostName;
			
			_sharedObject = SharedObject.getLocal(_hostName);
		}
		
		/**
		 * 根据 CookieName 获取数据
		 * @param cookieName
		 * @return 
		 * 
		 */		
		public static function getCookie(cookieName:String):*
		{
			if($.isNull(_sharedObject)) return null;
			
			return _sharedObject.data[cookieName];
		}
		
		/**
		 * 按照 CookieName 设置数据 
		 * @param cookieName
		 * @param cookieValue
		 * 
		 */		
		public static function setCookie(cookieName:String, cookieValue:*):void
		{
			if($.isNull(_sharedObject))
			{
				init();
			}
			
			_sharedObject.data[cookieName] = cookieValue;
			_sharedObject.flush();
		}
		
		/**
		 * 清除 SharedObject 数据 
		 * 
		 */		
		public static function clear():void
		{
			if(!$.isNull(_sharedObject))
			{
				_sharedObject.clear();
			}
		}
	}
}