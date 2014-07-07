package  net.buffer{
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:34:34
	 *
	 */
	public class StringBuffer implements IByteData {
		public static var instance:IByteData=new StringBuffer();

		public function read(buffer:ByteArray):* {
			return buffer.readUTF();
		}

		public function write(buffer:ByteArray, value:*):void {
			buffer.writeUTF(value);
		}
	}
}
