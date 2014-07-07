package utils
{
	/**
	 * 模拟时间
	 */
	public class TimerUtils extends BaseUtils
	{
		/**
		 * 计时器类别 
		 */		
		private var _frameName:String = "TimerUtils_Callback";
		
		/**
		 * 延迟时间。单位：毫秒 
		 */		
		private var _delay:int;
		
		/**
		 * 执行次数。
		 */		
		private var _repeatCount:int;
		
		/**
		 * 当前执行次数 
		 */		
		private var _currentCount:int;
		
		/**
		 *  计时器
		 */		
		private var _frameUtils:FrameUtils;
		
		/**
		 * 每次延迟触发函数 
		 */		
		private var _onCallback:Function;
		
		/**
		 * 执行结束触发函数 
		 */		
		private var _onCompleteCallback:Function;
		
		public function TimerUtils(delay:int, repeatCount:int = 0)
		{
			this._delay = delay;
			this._repeatCount = repeatCount;
		}
		
		/**
		 * 延迟时间 
		 * @return 
		 * 
		 */		
		public function get delay():int { return this._delay; }
		
		/**
		 * 执行次数 
		 * @return 
		 * 
		 */		
		public function get repeatCount():int { return this._repeatCount; }
		
		public function set repeatCount(value:int):void { this._repeatCount=value; }
		
		/**
		 * 当前执行次数 
		 * @return 
		 * 
		 */		
		public function get currentCount():int { return this._currentCount; }
		
		/**
		 * 注册回调函数 
		 * @param callback
		 * @param onCompleteCallback
		 * 
		 */		
		public function registerCallback(callback:Function = null, completeCallback:Function = null):void
		{
			this._onCallback = callback;
			this._onCompleteCallback = completeCallback;
		}
		
		/**
		 * 启动 
		 * 
		 */		
		public function start():void
		{
			this._currentCount = 0;
			
			this.stop();
			
			if($.isNull(this._frameUtils))
			{
				this._frameUtils = new FrameUtils();
				
				this._frameUtils.registerCallback(_frameName, onCallback, this._delay);
			}
			
			this._frameUtils.play();
		}
		
		public function isRunning():Boolean{
			return  this._frameUtils.isRunning();
		}
		
		
		/**
		 * 重新启动 
		 * 
		 */		
		public function restart():void
		{
			this._frameUtils.play();
		}
		
		/**
		 * 停止 
		 * 
		 */		
		public function stop():void
		{
			if(!$.isNull(this._frameUtils))
			{
				this._frameUtils.stop();
			}
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		override public function destory():void
		{
			this.stop();
			
			if(!$.isNull(this._frameUtils)){
				this._frameUtils.destory();
			}
			
			this._onCallback = null;
			this._onCompleteCallback = null;
		}
		
		/**
		 * 每次 Delay 回调函数 
		 * 
		 */		
		private function onCallback():void
		{
			this._currentCount ++;
			
			if(this._repeatCount > 0){
				
				if(this._currentCount > this._repeatCount){
					
					this.stop();
					
					if(this._onCompleteCallback is Function) this._onCompleteCallback();
					
					return;
				}	
			}
			
			if(this._onCallback is Function) this._onCallback();
		}
	}
}