package net
{
	public class DataPacketResult
	{
		/**
		 * 成功
		 */
		public static const SUCC:int=0;
		/**
		 * 失败
		 */
		public static const FAIL:int=1;
		
		/**
		 * 成功Info状态码
		 */
		public static const SUCC_CODE:int = 2;
		
		/**
		 * 失败Info状态码
		 */
		public static const FAIL_CODE:int = 3;
		
		/**
		 * 成功Tips状态码
		 */
		public static const SUCC_TIPS_CODE:int = 4;
		
		/**
		 * 失败Tips状态码
		 */
		public static const FAIL_TIPS_CODE:int = 5;
		public function DataPacketResult()
		{
		}
	}
}