package  net.buffer {
	
	import com.adobe.utils.DictionaryUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午11:10:41
	 *
	 */
	public class MapBuffer implements IByteData {
		private var keyBuffer:IByteData;

		private var valueBuffer:IByteData;

		public function MapBuffer(keyBuffer:IByteData, valueBuffer:IByteData) {
			this.keyBuffer=keyBuffer;

			this.valueBuffer=valueBuffer;
		}

		public function read(bytes:ByteArray):* {
			var dic:Dictionary=new Dictionary();
			var length:int = bytes.readShort();

			for (var i:int=0; i < length; i++) {
				dic[keyBuffer.read(bytes)]=keyBuffer.read(bytes);
			}
			return dic;
		}

		/**value-支持Dictionary*/
		public function write(bytes:ByteArray, value:*):void {
			bytes.writeShort(DictionaryUtil.getKeys(value as Dictionary).length);
			for(var key:* in value){
				keyBuffer.write(bytes,key);
				valueBuffer.write(bytes,value[key]);
			}
		}
	}
}
