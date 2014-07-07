package net.buffer {
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2013-4-9 下午3:53:47
	 * 可使用instantce获得实例
	 */
	public class BooleanBuffer implements IByteData {
		public static var instance:IByteData=new BooleanBuffer();

		public function BooleanBuffer() {

		}
		public function read(buffer:ByteArray):* {
			return buffer.readBoolean();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeBoolean(value);
		}
	}
}
