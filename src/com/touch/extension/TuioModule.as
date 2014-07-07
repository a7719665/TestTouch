package com.touch.extension
{
	import com.touch.MultTouchPoint;
	import com.touch.TouchModuleEvent;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.setTimeout;
	
	/**
	 * TUIO协议转换 
	 * TUIO标准 TUIO.org Ver 1.0
	 * @author IceFlame
	 */	
	public class TuioModule extends EventDispatcher implements ITouchModule
	{
		private const TUIO:String = "tuio";
		
		private var _width:Number;
		
		private var _height:Number;
		
		private var tuioHost:String;
		
		private var tuioPort:int;
		
		private var tuioSocket:XMLSocket;
		
		private var _touchPoint:Vector.<MultTouchPoint>;
		
		public function TuioModule()
		{
			super();
			_touchPoint = new Vector.<MultTouchPoint>();
		}
		
		/** 初始化 */
		public function init(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			connect();
		}
		
		/** 重设host */
		public function setHost(ip:String = "127.0.0.1",port:int = 3000,
								reconnection:Boolean = true):void{
			tuioHost = ip;
			tuioPort = port;
			if(reconnection)connect();
		}
		
		/** 开始连接 */
		public function connect():void{
			if(tuioSocket && tuioSocket.connected){
				tuioSocket.close();
				tuioSocket.removeEventListener(Event.CONNECT,onConnect);
				tuioSocket.removeEventListener(Event.CLOSE,onClose);
				tuioSocket.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				tuioSocket.removeEventListener(DataEvent.DATA,onData);
				tuioSocket = null;
			}
			if(!tuioSocket){
				tuioSocket = new XMLSocket();
				tuioSocket.addEventListener(Event.CONNECT,onConnect);
				tuioSocket.addEventListener(Event.CLOSE,onClose);
				tuioSocket.addEventListener(IOErrorEvent.IO_ERROR,ioError);
				tuioSocket.addEventListener(DataEvent.DATA,onData);
			}
			tuioSocket.connect(tuioHost,tuioPort);
		}
		
		/** 查找对应ID */
		public function getTouch(id:int):MultTouchPoint
		{
			for each(var touch:MultTouchPoint in _touchPoint){
				if(touch.id == id){
					return touch;
				}
			}
			return null;
		}
		
		/** 清空引用 */
		public function dispose():void{
			if(tuioSocket){
				if(tuioSocket.connected)tuioSocket.close();
				tuioSocket.removeEventListener(Event.CONNECT,onConnect);
				tuioSocket.removeEventListener(Event.CLOSE,onClose);
				tuioSocket.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				tuioSocket.removeEventListener(DataEvent.DATA,onData);
			}
			if(tuioSocket.connected){
				tuioSocket.close();
				tuioSocket = null;
			}
			while(_touchPoint.length > 0){
				_touchPoint.shift().dispose();
			}
		}
		
		//连接被关闭
		private function onClose(event:Event):void{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		//连接成功
		private function onConnect(event:Event):void {
			//this.dispatchEvent(new Event(Event.CONNECT));
		}
		
		//连接错误
		private function ioError(event:IOErrorEvent):void {
			setTimeout(connect,60000);//连接失败  60秒后重试
		}
		
		//数据到达
		private function onData(event:DataEvent):void {
			processMessage(XML(event.data));
		}
		
		//解析数据
		private function processMessage(msg:XML):void{
			trace(msg);
			var changeList:Vector.<MultTouchPoint> = new Vector.<MultTouchPoint>();
			//点是否存在  不存在则从列表中移除
			var node:XML;
			var touch:MultTouchPoint;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0].@VALUE == "alive")
				{
					for each (touch in _touchPoint)touch.isExist=false;
					
					for each(var aliveItem:XML in node.ARGUMENT.(@VALUE != "alive"))
					{
						touch = searchByRemoteName(int(aliveItem.@VALUE));
						if(touch){
							touch.isExist=true;
						}
					}
				}
			}
			//处理事件
			var remoteID:int;
			var x:Number;
			var y:Number;
			var touchObj:MultTouchPoint;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.@NAME == "/tuio/2Dcur")
				{
					if(node.ARGUMENT[0].@VALUE == "set") 
					{
						remoteID = int(node.ARGUMENT[1].@VALUE);
						x = Number(node.ARGUMENT[2].@VALUE) * _width;
						y = Number(node.ARGUMENT[3].@VALUE) * _height;
						
						touchObj=searchByRemoteName(remoteID);
						if(!touchObj){
							touchObj = new MultTouchPoint(0,x,y);
							touchObj.remoteID = remoteID;
							touchObj.remoteName = TUIO;
							_touchPoint.push(touchObj);
						}else{
							touchObj.x = x ;touchObj.y = y;
						}
						changeList.push(touchObj);
					}
				}
			}
			
			//处理不存在的点
			for(var i:int=_touchPoint.length-1;i>=0;i--){
				if(!_touchPoint[i].isExist){
					changeList.push(_touchPoint[i]);
					_touchPoint.splice(i,1);
				}
			}
			
			this.dispatchEvent(new TouchModuleEvent(TouchModuleEvent.REMOTE_CHANGE,changeList));
		}
		
		//根据远程触摸名
		private function searchByRemoteName(remoteID:int):MultTouchPoint{
			for each(var touch:MultTouchPoint in _touchPoint){
				if(touch.remoteID == remoteID){
					return touch;
				}
			}
			return null;
		}
		
	}
}