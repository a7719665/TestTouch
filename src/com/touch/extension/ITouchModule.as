package com.touch.extension
{
	import com.touch.MultTouchPoint;
	
	import flash.events.IEventDispatcher;

	public interface ITouchModule extends IEventDispatcher
	{
		function init(width:Number,height:Number):void;
		
		function getTouch(id:int):MultTouchPoint;
		
		function dispose():void;
	}
}