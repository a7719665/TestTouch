package  net.buffer {
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:41:29
	 * 可使用instance获得实例
	 */
	public class ByteBuffer implements IByteData {
		public static var instance:IByteData=new ByteBuffer();

		public function read(buffer:ByteArray):* {
			return buffer.readByte();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeByte(value.value);
		}
	}
}
