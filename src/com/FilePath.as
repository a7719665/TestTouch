package com
{
	

	/**
	 *  定义相关资源路径 
	 * @author lmh
	 * 
	 */	
	public class FilePath
	{
		public function FilePath()
		{
		}
		
		//		=======================================================
		//		图片相关
		//		=======================================================
		
		/**
		 * url路径
		 */
		public static var URL:String="";
		
		public static const CSSPATH:String="css/";
		
		private static const _TEMPSWF:String="temp.swf";
		private static const _MAINSWF:String="main.swf";
		private static const _MCSWF:String="mc.swf";
		private static const _COMPSWF:String="comp.swf";
		
		public static const PHOTO_GOODS:String="resource/photo/goods/";
		
		public static const QUESTIOIN_ADDRESS:String="assets/timu/";
		

		public static function get MAINSWF():String
		{
			return getCSSPath(_MAINSWF);
		}

		public static function get MCSWF():String
		{
			return getCSSPath(_MCSWF);
		}
		
		public static function get COMPSWF():String
		{
			return getCSSPath(_COMPSWF);
		}
		
		public static function get TEMPSWF():String{
			return getCSSPath(_TEMPSWF);
		}
		
		
		private static function getCSSPath(name:String):String{
			return URL+CSSPATH+name;
		}


	}
}