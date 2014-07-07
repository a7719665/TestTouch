package utils
{
	/**
	 * 日期显示【禁止实例化】
	 */
	public class DateUtils extends BaseUtils
	{
		public function DateUtils()
		{
			throw new Error("DateUtils can not be Instantiated!");
		}
		
		/**
		 * 输出格式 YYYY-MM-DD HH:MM:SS MS 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function dateToString(date:Date):String
		{
			return date.fullYear + "-" + ("0" + (date.month + 1)).slice(-2) + "-" + ("0" + date.date).slice(-2) + " " + ("0" + date.hours).slice(-2) + ":" + ("0" + date.minutes).slice(-2) + ":" + ("0" + date.seconds).slice(-2) + " " + date.milliseconds;
		}
		
		/**
		 * 输出格式 YYYY-MM-DD 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function dateToDateString(date:Date):String
		{
			return date.fullYear + "-" + ("0" + (date.month + 1)).slice(-2) + "-" + ("0" + date.date).slice(-2);
		}
		
		/**
		 * 输出格式 HH:MM:SS 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function dateToTimeString(date:Date):String
		{
			return ("0" + date.hours).slice(-2) + ":" + ("0" + date.minutes).slice(-2) + ":" + ("0" + date.seconds).slice(-2)
		}
		
		/**
		 * 输出格式 YYYY年MM月DD日 HH时MM分SS秒 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function dateToChineseString(date:Date):String
		{
			return date.fullYear + "年" + ("0" + (date.month + 1)).slice(-2) + "月" + ("0" + date.date).slice(-2) + "日" + " " + ("0" + date.hours).slice(-2) + "时" + ("0" + date.minutes).slice(-2) + "分" + ("0" + date.seconds).slice(-2) + "秒";
		}
		
		/**
		 * 输出格式 YYYY年MM月DD日 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function dateToChineseDateString(date:Date):String
		{
			return date.fullYear + "年" + ("0" + (date.month + 1)).slice(-2) + "月" + ("0" + date.date).slice(-2) + "日";
		}
		
		/**
		 * 输出格式 HH时MM分SS秒 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function dateToChineseTimeString(date:Date):String
		{
			return ("0" + date.hours).slice(-2) + "时" + ("0" + date.minutes).slice(-2) + "分" + ("0" + date.seconds).slice(-2) + "秒";
		}
		
		/**
		 * 输出格式 HH:MM:SS 
		 * @param milliseconds
		 * @return 
		 * 
		 */		
		public static function toString(milliseconds:Number):String
		{
			var totalSecond:int = milliseconds / 1000;
			
			var hours:int = totalSecond / (60 * 60); 
			
			var minutes:int = (totalSecond % (60 * 60)) / 60;
			
			var seconds:int = totalSecond % 60;
			
			return ("0" + hours).slice(-2) + ":" + ("0" + minutes).slice(-2) + ":" + ("0" + seconds).slice(-2);
		}
	}
}