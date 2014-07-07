package com.evt
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * 公用的事件派发器
	 */
	public class Dispatcher implements IEventDispatcher
	{
		private static var _me:Dispatcher;
		
		
		private var _dispatch:EventDispatcher;
		public function Dispatcher()
		{
			if(_me) throw Error("Dispatcher has init");
			
			_me=this;
			_dispatch=new EventDispatcher();
		}
		
		public static function get me():Dispatcher
		{
			if(!_me){
				new Dispatcher();
			}
			return _me;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatch.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatch.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatch.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatch.removeEventListener(type,listener,useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatch.willTrigger(type);
		}
	}
}