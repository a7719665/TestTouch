package net.buffer {
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:48:45
	 *
	 */
	public class LongBuffer implements IByteData {
		public static var instance:IByteData=new LongBuffer();

		public function read(buffer:ByteArray):* {
			var long:Number = (buffer.readInt() << 32) | buffer.readUnsignedInt()
			return long;
		}

		public function write(buffer:ByteArray, value:*):void {
			var str:String = value.value.toString(16);
			var lgth:int = 16 - str.length;
			for (var i:int = 0; i < lgth; i++) {
				str="0" + str;
			}

			var subStr:String = str.substr(0, 8);
			buffer.writeUnsignedInt(parseInt("0x" + subStr));
			subStr=str.substr(8, 8);
			buffer.writeUnsignedInt(parseInt("0x" + subStr));
		}
	}
}
