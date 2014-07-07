package net
{
	import com.evt.Dispatcher;
	import com.evt.GameEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * socket基类
	 */
	public class BaseSocket extends EventDispatcher
	{
		/**
		 * socket
		 */
		private var socket:Socket;
		
		/**
		 * 接收的数据长度
		 */
		private var dataLen:int;
		
		/**
		 * 请求Id
		 */
		private var requestId:int;
		
		/**
		 * 请求字典(requestId,callBack)
		 */
		private var requestDic:Dictionary;
		
		/**
		 * 写入方法
		 */
		private var _writeBuffer:IWriteBuffer;
		
		public var dataArr:Array;
		
		private var _timer:Timer;
		
		private var _host:String;
		
		private var _port:int;
		
		public function BaseSocket()
		{
			
		}
		
		public function initSocket(host:String,port:int,_writeBuffer:IWriteBuffer):void{
			requestDic=new Dictionary();
			this._writeBuffer=_writeBuffer;
			_timer=new Timer(1);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			dataArr=new Array();
			this._host=host;
			this._port=port;
			this.socket=new Socket();
			this.socket.addEventListener(Event.CONNECT, onConnect);
			this.socket.addEventListener(Event.CLOSE, onClose);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
		}
		
		public function socketCon():void{
			socket.connect(_host,_port);
		}

		/**
		 * 写入接口
		 */
		public function get writeBuffer():IWriteBuffer
		{
			return _writeBuffer;
		}

		/**
		 * @private
		 */
		public function set writeBuffer(value:IWriteBuffer):void
		{
			_writeBuffer = value;
		}

		/**
		 * 需要另外处理connect事件,可监听SocketEvent.CONNECTED
		 */
		private function onConnect(e:Event):void{
			if (this.socket.connected) {
				dispatchEvent(new SocketEvent(SocketEvent.CONNECTED,e));
			}
		}
		
		/**
		 * 需要另外处理close事件,可监听SocketEvent.CLOSE
		 */
		private function onClose(e:Event):void{
			trace("close");
			this.dispatchEvent(new SocketEvent(SocketEvent.CLOSE,e));
		}
		
		public function onSecurityError(e:SecurityErrorEvent):void{
			trace("SecurityError");
		}
		
		public function onIOError(e:IOErrorEvent):void{
			this.dispatchEvent(new SocketEvent(SocketEvent.IOERROR,e));
		}
		
		protected function onData(e:ProgressEvent):void{
			while (socket.bytesAvailable > 0) {
				if (socket.bytesAvailable < 3)
					return;
				if (dataLen == 0) {
					dataLen=socket.readInt();
				}
				//数据尚未接收完成
				if (dataLen > socket.bytesAvailable)
					return;
				
				var compress:Boolean = Boolean(socket.readByte()); // 是否压缩
				
				// 消息体 value
				var bytes:ByteArray=new ByteArray();
				socket.readBytes(bytes, 0, dataLen);
				if (compress)
					bytes.uncompress();
				bytes.position=0;
				var uid:int=bytes.readByte(); // 请求Id
				var actionId:int=bytes.readShort(); // 动作Id
				var status:int=bytes.readByte(); // 状态
				
				var data:DataPacket=new DataPacket();
				data.bytes=bytes;
				data.result=status;
				data.uid=uid;
				data.actionId=actionId;
				dataLen=0;// 数据读取完,初始化数据长度
				
				trace(data.toString());
				dataArr.push(data);
			}
		}
		private function timerHandler(e:TimerEvent):void{
			if(dataArr.length<=0){
				return;
			}
			var data:DataPacket=dataArr.shift();
			if(requestDic[data.uid]){
				data.args=requestDic[data.uid].args;
				delete requestDic[uid];
			}
			if(data.result==DataPacketResult.FAIL_CODE){
				this.dispatchEvent(new SocketEvent(SocketEvent.FAIL_CODE,data));
			}else if(data.result==DataPacketResult.FAIL_TIPS_CODE){
				this.dispatchEvent(new SocketEvent(SocketEvent.FAIL_CODE_TIP,data));
			}else{
				var args:Object=new Object();
				args["dataPacket"]=data;
				args["actionId"]=data.actionId;
//				_eelpoMVC.processors.getProcessorByName(Tags.CONTROLLER).call(args);
				Dispatcher.me.dispatchEvent(new GameEvent(data.actionId.toString(),args));
			}
			
			for(var uid:String in requestDic){
				if(requestDic[uid].time-getTimer()>5000){
					delete requestDic[uid];
				}
			}
		}
		
		public function sendBytes(bytes:ByteArray):void{
			socket.writeBytes(bytes);
		}
		
		/**
		 * @动作Id
		 * @参数列表
		 * @回调函数
		 */
		public function sendData(actionId:int,args:Array=null,notSendArgs:Array=null):void{
			if(!writeBuffer){
				throw new Error("writeBuffer not init");
			}
			if (this.socket.connected) {
				if(requestId>128){
					requestId=0;
				}
				requestId++;
				requestDic[requestId]={args:args,time:getTimer()};
				socket.writeBytes(writeBuffer.write(actionId,args,requestId));
				trace("send:actionId="+actionId);
				socket.flush();
				
			} else {
				onClose(null);
			}
		}
	}
}