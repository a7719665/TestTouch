package net.buffer{
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:40:34
	 *
	 */
	public class ShortBuffer implements IByteData {
		public static var instance:IByteData=new ShortBuffer();

		public function read(buffer:ByteArray):* {
			return buffer.readShort();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeShort(value.value);
		}
	}
}
