package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 图像处理【禁止实例化】
	 */	
	public class BitmapUtils extends BaseUtils
	{
		public function BitmapUtils()
		{
			throw new Error("BitmapUtils can not be Instantiated!");
		}
		
		/**
		 * 复制/克隆/拷贝 Bitmap 
		 * @param displayObject
		 * @return 
		 * 
		 */		
		public static function clone(displayObject:*):Bitmap
		{
			if($.isNull(displayObject)) return null;
			
			var bitmapData:BitmapData;
			
			if(displayObject is Bitmap){
				bitmapData = cloneBitmapData(displayObject.bitmapData);
			}else if(displayObject is MovieClip){
				bitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0);
				bitmapData.draw(displayObject as DisplayObject);
			}
			return new Bitmap(bitmapData);
		}
		
		/**
		 * 将 BitmapData 复制拆分成 BitmapData 数组 
		 * @param bitmapData
		 * @param offset
		 * @param minWidth
		 * @param minHeight
		 * @param maxWidth
		 * @param maxHeight
		 * @return 
		 * 
		 */		
		public static function createBitmapDataList(bitmapData:BitmapData, offset:Point, minWidth:int, minHeight:int, maxWidth:int, maxHeight:int):Array
		{
			var bitmapDataList:Array = [];
			
			var subX:int = 0;
			var subY:int  = 0;
			
			var data:BitmapData;
			
			while(subX <= maxWidth || subY <= maxHeight){
				
				if(subX + minWidth > maxWidth){
					
					subX = 0;
					
					subY += minHeight;
					
					if(subY + minHeight > maxHeight) return bitmapDataList;
					
					data = cloneBitmapData(bitmapData, new Rectangle(subX + offset.x, subY + offset.y, minWidth, minHeight), new Point());
					
					bitmapDataList.push(data);
					
					subX += minWidth;
					
				}else{
					
					data = cloneBitmapData(bitmapData, new Rectangle(subX + offset.x, subY + offset.y, minWidth, minHeight), new Point());
					
					bitmapDataList.push(data);
					
					subX += minWidth;
				}
			}
			
			return bitmapDataList;
		}
		
		/**
		 * 复制/克隆/拷贝 BitmapData 
		 * @param bitmapData
		 * @param rectangle
		 * @param point
		 * @return 
		 * 
		 */		
		public static function cloneBitmapData(bitmapData:BitmapData, rectangle:Rectangle = null, point:Point = null):BitmapData
		{
			if($.isNull(bitmapData)) return null;
			
			if($.isNull(rectangle)) rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
			if($.isNull(point)) point = new Point();
			
			var newBitmapData:BitmapData = new BitmapData(rectangle.width, rectangle.height, true, 0);
			
			newBitmapData.copyPixels(bitmapData,rectangle, point);
			
			return newBitmapData;
		}
		
		
		/**
		 * 垂直翻转 
		 * @param bt
		 * @return 
		 * 
		 */
		
		public static function upanddown(bt:BitmapData):BitmapData {
			var bmd:BitmapData = new BitmapData(bt.width, bt.height, true, 0x00000000);
			for (var xx:int=0; xx<bt.width; xx++) {
				for (var yy:int=0; yy<bt.height; yy++) {
					bmd.setPixel32(xx, bt.height-yy-1, bt.getPixel32(xx,yy));
				}
			}
			return bmd;
		}
		
		/**
		 * 水平翻转 
		 * @param bt
		 * @return 
		 * 
		 */        
		public static function rightandleft(bt:BitmapData):BitmapData {
			var bmd:BitmapData = new BitmapData(bt.width, bt.height, true, 0x00000000);
			for (var yy:int=0; yy<bt.height; yy++) {
				for (var xx:int=0; xx<bt.width; xx++) {
					bmd.setPixel32(bt.width-xx-1, yy, bt.getPixel32(xx,yy));
				}
			}
			return bmd;
		}
		
		
		/**
		 * 90翻转 
		 * @param bt
		 * @return 
		 * 
		 */        
		public static function turn90(bt:BitmapData):BitmapData {
			var bmd:BitmapData = new BitmapData(bt.height, bt.width, true, 0x00000000);
			for (var yy:int=0; yy<bt.height; yy++) {
				for (var xx:int=0; xx<bt.width; xx++) {
					bmd.setPixel32(yy,bt.width-xx, bt.getPixel32(xx,yy));
				}
			}
			return bmd;
		}
		
		/**
		 * 270翻转 
		 * @param bt
		 * @return 
		 * 
		 */ 
		public static function turn270(bt:BitmapData):BitmapData {
			var bmd:BitmapData = new BitmapData(bt.height, bt.width, true, 0x00000000);
			for (var yy:int=0; yy<bt.height; yy++) {
				for (var xx:int=0; xx<bt.width; xx++) {
					bmd.setPixel32(bt.height-yy-1,bt.width-xx, bt.getPixel32(xx,yy));
				}
			}
			return bmd;
		}
	}
}