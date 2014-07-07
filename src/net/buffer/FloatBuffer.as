package net.buffer {
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:47:11
	 *
	 */
	public class FloatBuffer implements IByteData {
		public static var instance:IByteData=new FloatBuffer();
		
		public function read(buffer:ByteArray):* {
			return buffer.readFloat();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeFloat(value.value);
		}
	}
}
