package utils
{
	import flash.utils.Dictionary;
	
	/**
	 * 本地化【禁止实例化】
	 */
	public class LanguageUtils
	{
		/**
		 * 前缀 
		 */		
		private static var _prefix:String = "\{\!";
		
		/**
		 * 后缀 
		 */		
		private static var _suffix:String = "\}";
		
		/**
		 * 语言配置 
		 */		
		private static var _dict:Dictionary;
		
		public function LanguageUtils()
		{
			throw new Error("LanguageUtils not Instantiated!");
		}
		
		/**
		 * 初始化 
		 * @param dict
		 * @param prefix
		 * @param suffix
		 * 
		 */		
		public static function init(dict:Dictionary, prefix:String = "\{\!", suffix:String = "\}"):void
		{
			_dict = dict;
			_prefix = prefix;
			_suffix = suffix;
		}
		
		/**
		 * 执行 
		 * @param key
		 * @param replace
		 * @return 
		 * 
		 */		
		public static function execute(key:String, replace:Object = null):String
		{
			if($.isNull(_dict) || $.isNullOrEmpty(key))
			{
				return "";
			}
			
			var data:String = _dict[key];
			
			if($.isNullOrEmpty(data)) return "";
			
			if(!$.isNull(replace))
			{
				for(var replaceKey:String in replace)
				{
					data = executeItem(data, replaceKey, replace[replaceKey]);
				}
			}
			
			return data;
		}
		
		/**
		 * 执行 Item 
		 * @param data
		 * @param replaceKey
		 * @param replaceValue
		 * @return 
		 * 
		 */		
		protected static function executeItem(data:String, replaceKey:String, replaceValue:String):String
		{
			var regExp:RegExp = new RegExp(_prefix + "(\\s+)?" + replaceKey + "(\\s+)?" + _suffix, "gi");

			data = data.replace(regExp, replaceValue);
			
			return data;
		}
	}
}
