package net
{
	import com.adobe.utils.DictionaryUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import net.buffer.ArrayBuffer;
	import net.buffer.BooleanBuffer;
	import net.buffer.ByteBuffer;
	import net.buffer.DoubleBuffer;
	import net.buffer.FloatBuffer;
	import net.buffer.IntBuffer;
	import net.buffer.LongBuffer;
	import net.buffer.MapBuffer;
	import net.buffer.ShortBuffer;
	import net.buffer.StringBuffer;
	import net.buffer.support.Byte;
	import net.buffer.support.Double;
	import net.buffer.support.Float;
	import net.buffer.support.IByteData;
	import net.buffer.support.Long;
	import net.buffer.support.Short;

	public class WriteBuffer implements IWriteBuffer
	{
		public function WriteBuffer()
		{
		}
		
		private function getWriter(arg:*):IByteData{
			if(arg is int){
				return IntBuffer.instance;
			}else if(arg is Short){
				return ShortBuffer.instance;
			}else if(arg is String){
				return StringBuffer.instance;
			}else if(arg is Boolean){
				return BooleanBuffer.instance;
			}else if(arg is Byte){
				return ByteBuffer.instance;
			}else if(arg is Double){
				return DoubleBuffer.instance;
			}else if(arg is Float){
				return FloatBuffer.instance;
			}else if(arg is Long){
				return LongBuffer.instance;
			}else if(arg is Array){
				var writer:IByteData = getWriter(arg[0]);
				return new ArrayBuffer(writer);
			}else if(arg is Dictionary){
				var keyWriter:IByteData=getWriter(DictionaryUtil.getKeys(arg as Dictionary)[0]);
				var valueWriter:IByteData=getWriter(DictionaryUtil.getValues(arg as Dictionary)[0]);
				return new MapBuffer(keyWriter,valueWriter);
			}else{
				throw new Error("not find arg type");
			}
		}
		
		public function write(actionId:int,args:Array,requestId:int):ByteArray{
			/**消息头*/
			var msgHeaderByteArr:ByteArray=new ByteArray();
			//写方法标示
			var msgInfoByteArr:ByteArray=new ByteArray();
			if (args != null) { //写参数
				for (var i:int=0; i < args.length; i++) {
					getWriter(args[i]).write(msgInfoByteArr,args[i]);
				}
			}
			//写消息长度
			msgHeaderByteArr.writeShort(3 + msgInfoByteArr.length);
			msgHeaderByteArr.writeByte(requestId);
			// actionId
			msgHeaderByteArr.writeShort(actionId);
			msgHeaderByteArr.writeBytes(msgInfoByteArr);
			
			return msgHeaderByteArr;
		}
	}
}