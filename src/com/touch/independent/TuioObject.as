package com.touch.independent
{
	import flash.display.InteractiveObject;

	public class TuioObject
	{
		/** 触摸id */
		public var id:int;
		
		/** 远程触摸编号 */
		public var remoteID:int;
		
		/** 指针对象 */
		public var target:InteractiveObject;
		
		/** 屏幕上的位置 */
		public var x:int;
		
		/** 屏幕上的位置 */
		public var y:int;
		
		/** 生效时候的位置 */
		public var startX:Number;
		
		/** 生效时候的位置 */
		public var startY:Number;
		
		/** 是否存在 */
		public var isExist:Boolean;
		
		public function TuioObject(touchID:int,x:Number,y:Number)
		{
			id = touchID;
			this.x = startX = x;
			this.y = startY = y;
			isExist = true;
		}
	}
}