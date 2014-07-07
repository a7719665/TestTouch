package com.touch
{
	import flash.display.InteractiveObject;
	import flash.utils.getTimer;

	/**
	 * 多点触摸点
	 */
	public class MultTouchPoint{
		
		/** 触摸id */
		public var id:int;
		
		/** 指针对象 */
		public var target:InteractiveObject;
		
		/** 原始指针对象 */
		public var startTarget:InteractiveObject;
		
		/** 屏幕上的位置 */
		public var x:int;
		
		/** 屏幕上的位置 */
		public var y:int;
		
		/** 刚刚的位置 */
		public var oldX:Number;
		
		/** 刚刚的位置 */
		public var oldY:Number;
		
		/** 生效时候的位置 */
		public var startX:Number;
		
		/** 生效时候的位置 */
		public var startY:Number;
		
		/** 生效时的时间 */
		public var startTime:Number;
		
		/** 远程触摸名 */
		public var remoteName:String;
		
		/** 远程触摸编号 */
		public var remoteID:int;
		
		/** 是否存在 */
		public var isExist:Boolean;
		
		/**
		 * 触摸点对象
		 */
		public function MultTouchPoint(id:int,x:int,y:int):void
		{
			this.id = id;
			this.x = startX = oldX = x;
			this.y = startY = oldY = y;
			startTime = getTimer();
			isExist = true;
		}
		
		/** 更新位置 */
		internal function updata(x:int,y:int):void{
			this.x = x;
			this.y = y;
		}
		
		/** 释放引用 仅作为远程触摸事件折调用使用*/
		public function dispose():void{
			target = null;
			startTarget = null;
		}
	}
}