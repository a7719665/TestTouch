package net
{
	import flash.utils.ByteArray;

	public interface IWriteBuffer
	{
		/**
		 * @actionId 接口Id
		 * @args 调用参数
		 */
		function write(actionId:int,args:Array,requestId:int):ByteArray;
	}
}