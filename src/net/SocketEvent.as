package net
{
	import flash.events.Event;

	public class SocketEvent extends Event
	{
		/**
		 * 连接关闭
		 */
		public static const CLOSE:String="CLOSE";
		/**
		 * 已连接
		 */
		public static const CONNECTED:String="CONNECTED";
		
		/**
		 * 流报错
		 */
		public static const IOERROR:String="IOERROR";
		
		/**
		 * 调用接口失败
		 */
		public static const FAIL:String="FAIL";
		
		/**
		 * 调用接口失败,返回code
		 */
		public static const FAIL_CODE:String="fail_code";
		
		/**
		 * 调用接口失败,返回code.弹出框
		 */
		public static const FAIL_CODE_TIP:String="fail_code_tip";
		
		/**
		 * 调用接口成功,返回code
		 */
		public static const SUCC_CODE:String="succ_code";
		
		/**
		 * 调用接口成功,返回code.弹出框
		 */
		public static const SUCC_CODE_TIP:String="succ_code_tip";
		
		
		
		public var data:Object;
		public function SocketEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data=data;
			super(type,bubbles,cancelable);
		}
	}
}