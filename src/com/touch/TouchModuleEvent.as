package com.touch
{
	import flash.events.Event;
	
	public class TouchModuleEvent extends Event
	{
		/** 远程触摸事件*/
		public static const REMOTE_CHANGE:String = "remote_change";
		
		private var _touchList:Vector.<MultTouchPoint>;
		
		public function TouchModuleEvent(type:String,touchList:Vector.<MultTouchPoint> = null)
		{
			super(type);
			_touchList = touchList;
		}
		
		/** 远程触摸列表*/
		public function get touchList():Vector.<MultTouchPoint>{
			return _touchList;
		}
	}
}