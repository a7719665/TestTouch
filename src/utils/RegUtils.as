package utils
{
	/**
	 * 正则【禁止实例化】
	 */
	public class RegUtils
	{
		public function RegUtils()
		{
			throw new Error("RegUtils can not be Instantiated!");
		}
		
		/**
		 * 去掉两端空字符串 
		 * @param text
		 * @return 
		 * 
		 */		
		public static function trim(text:String):String
		{
			if($.isNullOrEmpty(text)) return "";
			
			return text.replace(/(^\s*)|(\s*$)/g, "");
		}
		
		/**
		 * 去掉左边空字符串 
		 * @param text
		 * @return 
		 * 
		 */		
		public static function leftTrim(text:String):String
		{
			if($.isNullOrEmpty(text)) return "";
			
			return text.replace(/(^\s*)/g, ""); 
		}
		
		/**
		 * 去掉右边空字符串 
		 * @param text
		 * @return 
		 * 
		 */		
		public static function rightTrim(text:String):String
		{
			if($.isNullOrEmpty(text)) return "";
			
			return text.replace(/(\s*$)/g, ""); 
		}
	}
}