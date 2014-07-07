package utils
{
	/**
	* 错误处理【禁止实例化】
	*/
	public class ErrorUtils extends BaseUtils
	{
		public function ErrorUtils()
		{
			throw new Error("ErrorUtils can not be Instantiated!");
		}
		
		/**
		 *  触发
		 * @param level
		 * @param caption
		 * 
		 */		
		public static function occur(level:int, caption:String = ""):void
		{
			
		}
	}
}