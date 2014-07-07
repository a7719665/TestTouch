package net.buffer {
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:37:59
	 *
	 */
	public class IntBuffer implements IByteData {
		public static var instance:IByteData=new IntBuffer();

		public function read(buffer:ByteArray):* {
			return buffer.readInt();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeInt(value);
		}
	}
}
