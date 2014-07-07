package  net
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class EPSocket extends BaseSocket
	{
		private static var _me:EPSocket;
		private var _heartTimer:Timer;
		
		public function EPSocket()
		{
			super();
			
			this.addEventListener(SocketEvent.FAIL_CODE,onFailCode);
			this.addEventListener(SocketEvent.FAIL_CODE_TIP,onFailCodeTip);
			
//			heartTimer=new Timer((DataFactory.me.getSysConfig().playerIdlePeriod+30)*1000,1);
//			heartTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTick);
//			heartTimer.start();s
		}
		
		private function onTick(e:TimerEvent):void{
//			this.sendData(PlayerAction.HEART_BEAT);
		}
		
		private function onFailCode(e:SocketEvent):void{
		}
		
		private function onFailCodeTip(e:SocketEvent):void{
		}
		
		public static function get me():EPSocket{
			if(!_me)
				_me = new EPSocket();
			return _me;
		}

		/**
		 * 心跳计时器
		 */
		public function get heartTimer():Timer
		{
			return _heartTimer;
		}

		/**
		 * @private
		 */
		public function set heartTimer(value:Timer):void
		{
			_heartTimer = value;
		}
		
		
	}
}