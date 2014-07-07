package utils
{
	/**
	 * 模拟影片剪辑
	 */
	public class MovieClipUtils extends BaseUtils
	{
		/**
		 * 计时器类别 
		 */		
		private var _frameName:String = "MovieClipUtils_Callback";
		
		/**
		 * 总帧数 
		 */		
		private var _totalFrame:int;
		
		/**
		 * 关键帧 
		 */		
		private var _keyFrames:Array;
		
		/**
		 * 帧频
		 */		
		private var _frameRate:int;
		
		/**
		 * 当前帧  
		 */		
		private var _currentFrame:int = 1;
		
		/**
		 * 播放次数 
		 */		
		private var _loop:int = 0;
		
		/**
		 * 当前播放次数 
		 */		
		private var _currentLoop:int = 0;
		
		/**
		 * 计时器 
		 */		
		private var _frameUtils:FrameUtils;
		
		/**
		 * 每帧执行函数 
		 */		
		private var _onCallback:Function;
		
		/**
		 * 每关键帧执行 函数
		 */		
		private var _onKeyCallback:Function;
		
		/**
		 * 每次结束执行函数 
		 */		
		private var _onLoopCallback:Function;
		
		public function MovieClipUtils(totalFrame:int, keyFrames:Array = null, frameRate:int = 24)
		{
			this._totalFrame = totalFrame;
			this._keyFrames = keyFrames;
			this._frameRate = frameRate;
		}
		
		/**
		 * 帧频
		 * @return 
		 * 
		 */		
		public function get frameRate():int { return this._frameRate; }
		
		/**
		 * 当前帧
		 * @return 
		 * 
		 */		
		public function get currentFrame():int { return this._currentFrame; }
		
		/**
		 * 总帧数
		 * @return 
		 * 
		 */		
		public function get totalFrame():int { return this._totalFrame; }
		
		/**
		 * 总执行次数 
		 * @return 
		 * 
		 */		
		public function get loop():int { return this._loop; }
		
		/**
		 * 当前执行次数 
		 * @return 
		 * 
		 */		
		public function get currentLoop():int { return this._currentLoop; }
		
		/**
		 * 注册回调函数 
		 * @param callback
		 * @param onKeyCallback
		 * @param onLoopCallback
		 * 
		 */		
		public function registerCallback(callback:Function = null, keyCallback:Function = null, loopCallback:Function = null):void
		{
			this._onCallback = callback;
			this._onKeyCallback = keyCallback;
			this._onLoopCallback = loopCallback;
		}
		
		/**
		 * 播放 
		 * @param loop
		 * 
		 */		
		public function play(loop:int = 0):void
		{
			this._loop = loop;
			
			this._currentFrame = 1;
			
			this._currentLoop = 0;
			
			this.progressFrame(this._currentFrame);
			
			this.start();
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
		 * 跳转到帧播放 
		 * @param frame
		 * 
		 */		
		public function gotoAndPlay(frame:int):void
		{
			this._currentFrame = frame;
			
			this.progressFrame(this._currentFrame);
			
			this.start();
		}
		
		/**
		 * 跳转到帧停止 
		 * @param frame
		 * 
		 */		
		public function gotoAndStop(frame:int):void
		{
			this._currentFrame = frame;
			
			this.progressFrame(this._currentFrame);
			
			this.stop();
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		override public function destory():void
		{
			this.stop();
			
			if(!$.isNull(this._frameUtils)){
				this._frameUtils.unRegisterCallback(this._frameName, onCallback);
				this._frameUtils = null;
			}
			
			this._keyFrames = null;
		}
		
		/**
		 * 每帧执行函数 
		 * @param frame
		 * 
		 */		
		private function progressFrame(frame:int):void
		{
			if(this._onCallback is Function) this._onCallback(frame);	
		}
		
		/**
		 * 每次关键帧执行函数 
		 * @param frame
		 * 
		 */		
		private function progressKeyFrame(frame:int):void
		{
			if(this._onKeyCallback is Function) this._onKeyCallback(frame);
		}
		
		/**
		 * 每次结束执行函数 
		 * 
		 */		
		private function progressLoop():void
		{
			if(this._onLoopCallback is Function) this._onLoopCallback();
		}
		
		/**
		 * 启动计时器 
		 * 
		 */		
		private function start():void
		{ 
			this.stop();
			
			if($.isNull(this._frameUtils))
			{
				var delay:int = int(1000 / this._frameRate);
				
				this._frameUtils = new FrameUtils();
				
				this._frameUtils.registerCallback(this._frameName, onCallback, delay);
			}
			
			this._frameUtils.play();
		}
		
		/**
		 * 计时器回调函数 
		 * 
		 */		
		private function onCallback():void
		{
			this._currentFrame ++;
			
			if(this._currentFrame > this._totalFrame){
				
				if(this._loop > 0){
					
					this._currentLoop ++;
					
					if(this._currentLoop >= this._loop){
						
						this.stop();
						
						this.progressLoop();
						
						return;
						
					}else{
						this._currentFrame = 1;
					}
				}else{
					this._currentFrame = 1;
				}
			}
			
			this.progressFrame(this._currentFrame);
			
			if(this._keyFrames != null && this._keyFrames.length > 0 && this._keyFrames.indexOf(this._currentFrame) != -1){
				this.progressKeyFrame(this._currentFrame);
			}
		}
	}
}