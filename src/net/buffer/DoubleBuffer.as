package net.buffer{
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:45:55
	 *
	 */
	public class DoubleBuffer implements IByteData {
		public static var instance:IByteData=new DoubleBuffer();

		public function read(buffer:ByteArray):* {
			return buffer.readDouble();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeDouble(value.value);
		}
	}
}
