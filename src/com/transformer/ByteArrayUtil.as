package com.transformer
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class ByteArrayUtil
	{
		public function ByteArrayUtil()
		{
		}
		
		public static function BytesToBitmapData($bytes:ByteArray):BitmapData{
			if(!$bytes)return null;
			$bytes.position = 0;
			var bytes:ByteArray=$bytes;
			//bytes.uncompress();
			var width:int=bytes.readShort();
			var height:int=bytes.readShort();
			var copy:BitmapData=new BitmapData(width,height,true,0);
			copy.setPixels(copy.rect,bytes);
			return copy;
		}
		
		public static function BitmapDataToBytes(bitmapData:BitmapData):ByteArray{
			if(!bitmapData)return null;
			var bytes:ByteArray=new ByteArray();
			bytes.writeShort(bitmapData.width);
			bytes.writeShort(bitmapData.height);
			bytes.writeBytes(bitmapData.getPixels(bitmapData.rect));
			//bytes.compress();
			return bytes;
		}
	}
}