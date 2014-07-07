package com.touch
{
	import flash.events.Event;
	
	public class MultTouchEvent extends Event
	{
		/** 触摸事件 */
		public static const TOUCH:String = "touch";
		
		/** 复杂操作 如果由Help生成则此事件不冒泡 */
		public static const GESTURE:String = "gesture";
		
		/** 选择操作 如果由Help生成则此事件不冒泡 */
		public static const SELECT:String = "select";
		
		/** 悬停操作 如果由Help生成则此事件不冒泡 */
		public static const HOVER:String = "hover";
		
		
		/** X轴的位移量 */
		public var moveX:Number;
		
		/** Y轴的位移量 */
		public var moveY:Number;

		/** 夹捏缩放量 */
		public var scale:Number;
		
		/** 旋转量 */
		public var rota:Number;
		
		private var _touchType:int;
		
		private var _touchPoint:MultTouchPoint;
		
		public function MultTouchEvent(type:String,bubble:Boolean = false,
			touchPhase:int = 0,touchObject:MultTouchPoint = null)
		{
			super(type,bubble);
			_touchType = touchPhase;
			_touchPoint = touchObject;
		}
		
		/** 触摸事件对应的触摸点对象 */
		public function get touchPoint():MultTouchPoint{
			return _touchPoint;
		}
		
		/** 触摸事件的类型 */
		public function get touchType():int{
			return _touchType;
		}
		
		/** 触摸的ID */
		public function get touchId():int{
			return _touchPoint.id;
		}
		
		/** 触摸的位置 */
		public function get stageX():int{
			return _touchPoint.x;
		}
		
		/** 触摸的位置 */
		public function get stageY():int{
			return _touchPoint.y;
		}
	}
}