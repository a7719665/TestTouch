package com.transformer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *  DisplayObjectTransformer 类有两个静态函数：一个用来裁剪矩形；一个用来裁剪任意形状。
	 */
	public class DisplayObjectTransformer
	{
		
	    /**
	     *  构造函数
	     *  <p>本类所有方法均为静态方法，不应创建实例。</p>
	     */
		public function DisplayObjectTransformer()
		{
			
		}
		
		
		
		//------------------------------------------------------------
		//
		//  裁剪
		//
		//------------------------------------------------------------
	    /**
	     *  裁剪指定矩形区域并返回一个包含结果的 BitmapData 对象。
	     *
	     *  @param target 需要裁剪的显示对象。
	     *
	     *  @param width 位图图像的宽度，以像素为单位。
	     *
	     *  @param height 位图图像的高度，以像素为单位。
	     *
	     *  @param distanceX 切割矩形左上角的点到显示对象矩形左上角的点的水平距离。注意：左上角的点不一定就是注册点（0, 0）外，变形过的显示对象就是一个例外。
	     *
	     *  @param distanceY 切割矩形左上角的点到显示对象矩形左上角的点的垂直距离。注意：左上角的点不一定就是注册点（0, 0）外，变形过的显示对象就是一个例外。
	     *
	     *  @param transparent 指定裁剪后的位图图像是否支持每个像素具有不同的透明度。默认值为 true（透明）。若要创建完全透明的位图，请将 transparent 参数的值设置为 true，将 fillColor 参数的值设置为 0x00000000（或设置为 0）。将 transparent 属性设置为 false 可以略微提升呈现性能。
	     *
	     *  @param fillColor 用于填充裁剪后的位图图像区域背景的 32 位 ARGB 颜色值。默认值为 0x00000000（纯透明黑色）。
	     *
	     *  @returns 返回裁剪后的 BitmapData 对象。
	     */
		public static function cutOutRect( target:DisplayObject, distanceX:Number, distanceY:Number, width:Number, height:Number, transparent:Boolean = true, fillColor:uint = 0x00000000 ):BitmapData
		{
			var m:Matrix = target.transform.matrix;
			m.tx -= target.getBounds( target.parent ).x + distanceX;
			m.ty -= target.getBounds( target.parent ).y + distanceY;
			
			var bmpData:BitmapData = new BitmapData( width, height, transparent, fillColor );
			bmpData.draw( target, m );
			
			return bmpData;
		}
		
		public static function cutOutRect2( target:Bitmap, distanceX:Number, distanceY:Number, width:Number, height:Number,transparent:Boolean = true, fillColor:uint = 0x00000000):BitmapData
		{
			var    bmpData:BitmapData=new BitmapData(width,height,transparent, fillColor);
			bmpData.copyPixels(target.bitmapData,new Rectangle(distanceX,distanceY,width,height),new Point(0,0));
			
			return bmpData;
		}
		public static function cutOutRect3( target:BitmapData, distanceX:Number, distanceY:Number, width:Number, height:Number,transparent:Boolean = true, fillColor:uint = 0x00000000):BitmapData
		{
			var    bmpData:BitmapData=new BitmapData(width,height,transparent, fillColor);
 			bmpData.copyPixels(target,new Rectangle(distanceX,distanceY,width,height),new Point(0,0));
			
			return bmpData;
		}
		
		
		
		/**
		 *  超级裁剪工具！可裁剪任意形状！给定一个裁剪目标和一个模板，就可根据模板裁剪出形状相配的 BitmapData 数据。
		 *
		 *  @param target 需要裁剪的显示对象。
		 *
		 *  @param template 裁剪模板，可以是任意形状。
		 *
		 *  @returns 返回裁剪后的 BitmapData 对象。
		 */
		public static function cutOutSuper( target:DisplayObject, template:DisplayObject ):BitmapData
		{
			var rectTarget:Rectangle = target.transform.pixelBounds;
			var rectTemplate:Rectangle = template.transform.pixelBounds;
			var targetBitmapData:BitmapData = DisplayObjectTransformer.cutOutRect( target, 0, 0, rectTarget.width, rectTarget.height, true, 0x00000000 );
			var templateBitmapData:BitmapData = DisplayObjectTransformer.cutOutRect( template, 0, 0, rectTemplate.width, rectTemplate.height, true, 0x00000000 );
			
			for( var pixelY:int = 0; pixelY < rectTemplate.height; pixelY++ )
			{
				for( var pixelX:int = 0; pixelX < rectTemplate.width; pixelX++ )
				{
					if( templateBitmapData.getPixel( pixelX, pixelY ) != 0 )
					{
						var color:uint = targetBitmapData.getPixel32( pixelX + rectTemplate.x - rectTarget.x, pixelY + rectTemplate.y - rectTarget.y );
						templateBitmapData.setPixel32( pixelX, pixelY, color );
					}
				}
			}
			
			return templateBitmapData;
			
		}
		
		
		
	}
}