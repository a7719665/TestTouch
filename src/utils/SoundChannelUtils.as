package utils
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * 音频处理
	 */
	public class SoundChannelUtils extends BaseUtils
	{
		/**
		 * Sound 类 
		 */		
		private var _sound:Sound;
		
		/**
		 * SoundChannel 类 
		 */		
		private var _soundChannel:SoundChannel;
		
		/**
		 * 播放次数 
		 */		
		private var _loop:int;
		
		/**
		 * 当前播放次数 
		 */		
		private var _currentLoop:int;
		
		/**
		 * 声音停留位置 
		 */		
		private var _position:int;
		
		/**
		 * 音量 
		 */		
		private var _volume:Number = .5;
		
		public function SoundChannelUtils(sound:Sound)
		{
			this._sound = sound;
		}
		
		/**
		 * 获取音量大小 
		 * @return 
		 * 
		 */		
		public function get volume():Number { return this._volume; }
		
		/**
		 * 设置音量大小 
		 * @param value
		 * 
		 */		
		public function set volume(value:Number):void
		{
			this._volume = value;
			
			if(!$.isNull(this._soundChannel))
			{
				var soundTransform:SoundTransform = this._soundChannel.soundTransform;
				soundTransform.volume = this._volume;
				
				this._soundChannel.soundTransform = soundTransform;
			}
		}
		
		/**
		 * 播放 
		 * @param loop
		 * @return 
		 * 
		 */		
		public function play(loop:int = 0):void
		{
			this._position = 0;
			this._currentLoop = 0;
			this._loop = loop;
			
			if($.isNull(this._sound)) return;
			
			onSoundCompleteHandler(null);
		}
		
		/**
		 * 暂停 
		 * @param status
		 * 
		 */		
		public function pause(status:Boolean = true):void
		{
			if($.isNull(this._soundChannel)) return;
			
			if(status)
			{
				this._position = this._soundChannel.position;
				this.stop();
			}else{
				onSoundCompleteHandler(null);
			}
		}
		
		/**
		 * 停止 
		 * 
		 */		
		public function stop():void
		{
			if($.isNull(this._soundChannel)) return;
			
			if(this._soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			}
			this._soundChannel.stop();
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		override public function destory():void
		{
			this.stop();
			
			if(!$.isNull(this._soundChannel))
			{
				this._soundChannel = null;
				this._sound = null;
			}
		}
		
		/**
		 * 声音事件处理函数 
		 * @param eventHandler
		 * 
		 */		
		private function onSoundCompleteHandler(eventHandler:Event):void
		{
			if(!$.isNull(eventHandler))
			{
				if(this._loop >= 0)
				{
					this._currentLoop ++;
					
					if(this._currentLoop >= this._loop)
					{
						this.stop();
					}
				}
			}
			
			if(this._soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			}
			this._soundChannel = this._sound.play(this._position);
			this._soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
		}
	}
}