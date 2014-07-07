package com.touch.simulator
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TouchEvent;
	import flash.net.Socket;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	/**
	 * 远程触摸控制端
	 * 协议标准 2011-12
	 * @author IceFlame
	 */	
	public class MultTouchControl extends Sprite
	{
		private const MAX_RETRY:int = 3;
		
		private var _socket:Socket;
		
		private var _host:String;
		
		private var _port:int;
		
		private var _width:int;
		
		private var _height:int;
		
		private var _reTry:int=0;
		
		private var _mousePoint:TouchControlPoint;
		
		private var _touchList:Vector.<TouchControlPoint>;
		
		/**
		 * 一个远程控制器
		 */
		public function MultTouchControl(width:int,height:int)
		{
			super();
			_width = width;
			_height = height;
			
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			
			_socket=new Socket();
			_touchList=new Vector.<TouchControlPoint>();
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
		}
		
		/**
		 * 连接到远程服务器
		 */
		public function startTouch(ip:String="127.0.0.1",port:int = 763):void{
			_host=ip;
			_port = port;
			_socket.addEventListener(Event.CONNECT,onConnect);
			_socket.addEventListener(Event.CLOSE,onClosed);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			startConnect();
		}
		
		//开始尝试连接
		private function startConnect():void{
			_reTry++;
			_socket.connect(_host,_port);
		}
		
		//错误
		private function onError(event:IOErrorEvent):void{
			if(_reTry >= MAX_RETRY){
				_reTry = 0;
				setTimeout((startConnect,60000);
			}else{
				setTimeout(startConnect,6000);
			}
		}
		
		//链接成功  开始监听触摸
		private function onConnect(event:Event):void{
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchDown);
			this.addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			this.addEventListener(TouchEvent.TOUCH_END,onTouchEnd);
			this.addEventListener(Event.ENTER_FRAME,sendTouchEvent);
			
			_reTry=0;
			setTimeout(startConnect,60000);
		}
		
		//链接断开中断
		private function onClosed(event:Event):void{
			this.removeEventListener(TouchEvent.TOUCH_BEGIN,onTouchDown);
			this.removeEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			this.removeEventListener(TouchEvent.TOUCH_END,onTouchEnd);
			this.removeEventListener(Event.ENTER_FRAME,sendTouchEvent);
		}
		
		//查找ID
		private function findTouchPoint(touchID:int):TouchControlPoint{
			for each (var touch:TouchControlPoint in _touchList){
				if(touch.touchID == touchID)return touch;
			}
			return null 
		}
		
		//发触摸事件
		private function sendTouchEvent(event:Event):void{
			var touchMove:int = 0;
			var xml:XML=new XML(<dt><dt>dt</dt></dt>);
			for each (var touch:TouchControlPoint in _touchList){
				if(touch.isMoved){
					xml.appendChild(
						<obj>
							<id>{touch.touchID}</id>
							<state>{touch.isExist.toString()}</state>
							<x>{touch.x}</x>
							<y>{touch.y}</y>
						</obj>
					);
					touchMove++;
				}
			}
			for(var i:int = _touchList.length - 1;i >= 0 ; i--){
				if(!_touchList[i].isExist){
					_touchList.splice(i,1);
				}
			}
			if(touchMove > 0){
				var xmlByte:ByteArray=new ByteArray();
				xmlByte.writeUTFBytes(xml);
				xmlByte.compress();
				_socket.writeBytes(xmlByte);
				_socket.flush();
			}
		}
		
		private function onTouchDown(event:TouchEvent):void{
			_touchList.push(new TouchControlPoint(event.touchPointID,event.localX,event.localY));
		}
		
		private function onTouchMove(event:TouchEvent):void{
			var touch:TouchControlPoint = findTouchPoint(event.touchPointID);
			if(touch)touch.updata(event.localX,event.localY);
		}
		
		private function onTouchEnd(event:TouchEvent):void{
			var touch:TouchControlPoint = findTouchPoint(event.touchPointID);
			if(touch)touch.remove(event.localX,event.localY);
		}
	}
}