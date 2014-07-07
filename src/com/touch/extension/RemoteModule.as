package com.touch.extension
{
	import com.touch.MultTouchPoint;
	import com.touch.TouchModuleEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * 远程触摸接收端
	 * 协议标准 IF-2011-12
	 * @author IceFlame
	 */
	public class RemoteModule extends EventDispatcher implements ITouchModule
	{
		private var _serverSocket:ServerSocket;
		
		private var _socketList:Vector.<Socket>;
		
		private var _touchPoint:Vector.<MultTouchPoint>;
		
		private var _host:String;
		
		private var _port:int;
		
		private var _width:Number;
		
		private var _height:Number;
		
		/** 远程触摸服务，接收其他电脑传入的数据并模拟为触摸  */
		public function RemoteModule(){
			_socketList=new Vector.<Socket>();
			_touchPoint=new Vector.<MultTouchPoint>();
		}
		
		/** 初始化  */
		public function init(width:Number,height:Number):void{
			_width = width;
			_height = height;
		}
		
		/** 重设host */
		public function setHost(ip:String = "127.0.0.1",port:int = 763,
								reconnection:Boolean = true):void{
			_host = ip;
			_port = port;
			if(reconnection)connect();
		}
		
		/** 开始监听 */
		public function connect():void{
			if(_serverSocket){
				if(_serverSocket.listening)_serverSocket.close();
				_serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT,onConnect);
				_serverSocket.close();
				_serverSocket = null;
			}
			if(!_serverSocket){
				_serverSocket = new ServerSocket();
				_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT,onConnect);
			}
			_serverSocket.bind(_port,_host);
			_serverSocket.listen();
		}
		
		/** 清空引用 */
		public function dispose():void{
			if(_serverSocket){
				_serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT,onConnect);
				if(_serverSocket.listening)_serverSocket.close();
			}
			clearSocket();
			_touchPoint.length = 0;
		}
		
		/** 查找ID */
		public function getTouch(id:int):MultTouchPoint{
			for each(var touch:MultTouchPoint in _touchPoint){
				if(touch.id == id) return touch;
			}
			return null;
		}
		
		//清除连接
		private function clearSocket():void{
			var len:int = _socketList.length;
			for(var i:int = 0 ; i < len ; i++){
				_socketList[i].close();
				_socketList[i].removeEventListener(Event.CLOSE,closeConnect);
				_socketList[i].removeEventListener(ProgressEvent.SOCKET_DATA,onData);
			}
			_socketList.length = 0;
		}
		
		//链接打开则连接该点
		private function onConnect(event:ServerSocketConnectEvent):void{
			var socket:Socket = event.socket;
			socket.addEventListener(Event.CLOSE,closeConnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,onData);
			_socketList.push(socket);
		}
		
		//连接关闭 移除连接  清空 Touch
		private function closeConnect(event:Event):void{
			var len:int = _socketList.length;
			for (var i:int=0;i<len ;i++){
				if(_socketList[i].remoteAddress==event.target.remoteAddress){
					_socketList[i].removeEventListener(Event.CLOSE,closeConnect);
					_socketList[i].removeEventListener(ProgressEvent.SOCKET_DATA,onData);
					var remoteName:String = _socketList[i].remoteAddress + ":" + _socketList[i].remotePort;
					_socketList.splice(i,1);
					for(var k:int = _touchPoint.length - 1 ; k >= 0 ;k-- ){
						if(_touchPoint[k].remoteName == remoteName){
							_touchPoint[k].dispose();
							_touchPoint.splice(k,1);
						}
					}
					return;
				}
			}
		}
		
		//数据到达
		private  function onData(event:ProgressEvent):void{
			var message:ByteArray=new ByteArray();
			event.target.readBytes(message,0,event.target.bytesAvailable );
			var xml:XML;
			try{
				message.uncompress();//检查xml
				xml = XML(message.toString());
				if(xml.dt!="dt")return;
			}catch(error:Error){
				return;
			}
			var changeList:Vector.<MultTouchPoint> = new Vector.<MultTouchPoint>();
			var remoteName:String = event.target.remoteAddress + ":" +  event.target.remotePort;
			
			var node:XML;
			var remoteID:int;
			var state:String;
			var x:int;
			var y:int;
			var len:int = xml.obj.length();
			var touch:MultTouchPoint ;
			for(var i:int = 0 ; i< len ; i++){
				node = xml.obj[i];
				remoteID = int(node.id);
				state = node.state;
				x = Number(node.x);
				y = Number(node.y);
				
				touch = isExist(remoteName,remoteID);
				if(!touch){
					touch = new MultTouchPoint(0,x,y);
					touch.remoteID = remoteID;
					touch.remoteName = remoteName;
					_touchPoint.push(touch);
				}else{
					if(state == "true"){
						touch.x = x ;touch.y = y;
					}else{
						touch.isExist = false;
						for(var k:int = _touchPoint.length-1; k >= 0 ; k--){
							if(_touchPoint[k] == touch){
								_touchPoint.splice(k,1);
								break;
							}
						}
					}
				}
				changeList.push(touch);
			}
			
			this.dispatchEvent(new TouchModuleEvent(TouchModuleEvent.REMOTE_CHANGE,changeList));
		}
		
		//检查是否存在点
		private function isExist(remoteName:String,remoteID:int):MultTouchPoint{
			for each(var temp:MultTouchPoint in _touchPoint){
				if(temp.remoteID == remoteID &&　temp.remoteName == remoteName){
					return temp;
				}
			}
			return null;
		}
	}
}