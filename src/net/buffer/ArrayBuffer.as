package net.buffer {
	import flash.utils.ByteArray;
	
	import net.buffer.support.IByteData;

	/**
	 * @author tz
	 * createDate: 2012-12-6 上午10:51:00
	 * 
	 */
	public class ArrayBuffer implements IByteData {
		
		private var writeAndRead:IByteData;
		
		public function ArrayBuffer(writeAndRead:IByteData) {
			this.writeAndRead=writeAndRead;
		}

		
		public function write(buffer:ByteArray,args:*):void{
			buffer.writeShort(args.length);
			for each (var o:* in args) {
				writeAndRead.write(buffer,o);
			}
		}
		
		public function read(buffer:ByteArray):*{
			var length:int = buffer.readShort();
			var value:Array=new Array();
			for(var i:int=0;i<length;i++){
				value.push(writeAndRead.read(buffer));
			}
			return value;
		}
		
	}
}
