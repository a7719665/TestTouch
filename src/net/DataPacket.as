package net
{
	import flash.utils.ByteArray;

	/**
	 * 返回数据包
	 */
	public class DataPacket
	{
		/**动作Id*/
		public var actionId:int;
		/**数据*/
		public var bytes:ByteArray;
		/**请求流水号Id**/
		public var uid:int;
		/**结果--详情参见DataPacketResult*/
		public var result:int;
		/**参数*/
		public var args:Array;
		public function DataPacket()
		{
		}
		
		public function toString():String{
			return "receive:actionId="+actionId+"----------"+"result="+result;
		}
	}
}