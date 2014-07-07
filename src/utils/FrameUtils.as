package utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * 模拟计时器
	 */
	public class FrameUtils extends BaseUtils
	{
		/**
		 * 暂停状态 
		 */		
		public static var pause:Boolean = false;
		
		/**
		 * 计时器 
		 */		
		private var _movieClip:MovieClip;
		
		/**
		 * 当前时间 getTimer(); 
		 */		
		private var _currentTime:int;
		
		/**
		 * 回调函数列表 
		 */		
		private var _dictionary:Dictionary;
		
		public function FrameUtils(){}
		
		/**
		 * 播放 
		 * 
		 */		
		public function play():void
		{
			this._currentTime = getTimer();
			
			if($.isNull(this._movieClip))
			{
				this._movieClip = new MovieClip();
			}
			
			if(!this._movieClip.hasEventListener(Event.ENTER_FRAME)){
				this._movieClip.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
			this._movieClip.play();	
		}
		
		public function isRunning():Boolean{
			return  this._movieClip.hasEventListener(Event.ENTER_FRAME)
		}
		
		/**
		 * 停止 
		 * 
		 */		
		public function stop():void
		{
			if($.isNull(this._movieClip)) return;
			
			if(this._movieClip.hasEventListener(Event.ENTER_FRAME))
			{
				this._movieClip.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
			this._movieClip.stop();
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		override public function destory():void
		{
			this.stop();
			
			this._movieClip = null;

			this._dictionary = null;
		}
		
		/**
		 * 注册侦函数 
		 * @param type
		 * @param callback
		 * @param delay
		 * 
		 */		
		public function registerCallback(type:String, callback:Function, delay:int = 1000):void
		{
			if($.isNull(this._dictionary)) this._dictionary = new Dictionary();
			
			var frameCallback:FrameCallback = new FrameCallback(callback, delay);
			
			if(!$.isNull(_dictionary[type])){
				
				var index:int = this.getCallback(callback, _dictionary[type]);
				
				if(index == -1){
					
					_dictionary[type].push(frameCallback);
					
				}
			}else{
				
				_dictionary[type] = [frameCallback];
				
			}
		}
		
		/**
		 * 移除侦函数 
		 * @param type
		 * @param callback
		 * 
		 */		
		public function unRegisterCallback(type:String, callback:Function):void
		{
			if($.isNull(this._dictionary)) return;
			
			if(!$.isNull(_dictionary[type])){
				
				var index:int = this.getCallback(callback, _dictionary[type]);
				
				if(index != -1){
					
					_dictionary[type].splice(index, 1);
					
				}
			}
		}
		
		/**
		 * Event.ENTER_FRAME 
		 * @param eventHandler
		 * 
		 */		
		private function onEnterFrameHandler(eventHandler:Event):void
		{
			if(!pause)
			{
				this.enterFrameCallback();
			}
		}
		
		/**
		 * Event.ENTER_FRAME 处理 
		 * 
		 */		
		private function enterFrameCallback():void
		{
			var subTime:int = getTimer() - this._currentTime;
			
			if(!$.isNull(this._dictionary))
			{
				for(var key:String in this._dictionary){
					
					for each(var frameCallback:FrameCallback in this._dictionary[key] as Array){
						
						var currentTime:int = subTime + frameCallback.currentDelay;
						
						if(currentTime >= frameCallback.delay){
							
							var tickNum:int = int(currentTime / frameCallback.delay);
							
							var modNum:int = currentTime % frameCallback.delay;
							
							while(tickNum > 0){
								
								frameCallback.callback();
								
								tickNum --;
							}
							
							frameCallback.currentDelay = modNum;
							
						}else{
							
							frameCallback.currentDelay += subTime;
							
						}
						
					}
				}
			}
			
			this._currentTime = getTimer();
		}
		
		/**
		 * 获取侦函数 
		 * @param callback
		 * @param list
		 * @return 
		 * 
		 */		
		private function getCallback(callback:Function, list:Array):int
		{
			var index:int = 0;
			for each(var frameCallback:FrameCallback in list){
				if(frameCallback.callback == callback) return index;
				index ++;
			}
			return -1;
		}
	}
}

class FrameCallback
{
	public var callback:Function;
	public var delay:int;
	public var currentDelay:int;
	
	public function FrameCallback(callback:Function, delay:int){
		this.callback = callback;
		this.delay = delay;
	}
}