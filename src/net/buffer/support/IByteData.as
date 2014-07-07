package net.buffer.support
{
	import flash.utils.ByteArray;

	/**
	 * 数据读写方法
	 */
	public interface IByteData
	{
		function write(buffer:ByteArray,args:*):void;
		
		function read(buffer:ByteArray):*;
	}
}