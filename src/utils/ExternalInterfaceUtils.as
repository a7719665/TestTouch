package utils
{
	import flash.external.ExternalInterface;
	
	/**
	 * 外部接口处理【禁止实例化】
	 */
	public class ExternalInterfaceUtils extends BaseUtils
	{
		public function ExternalInterfaceUtils()
		{
			throw new Error("ExternalInterfaceUtils can not be Instantiated!");
		}
		
		/**
		 * 调用 JavaScript 函数
		 * @param functionName
		 * @param parameters
		 * 
		 */		
		public static function call(functionName:String, ... parameters):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call(functionName, parameters); 
			}
		}
		
		/**
		 *  创建函数等待 JavaScript 调用
		 * @param functionName
		 * @param closure
		 * 
		 */		
		public static function addCallback(functionName:String, closure:Function):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback(functionName, closure);
			}
		}
	}
}