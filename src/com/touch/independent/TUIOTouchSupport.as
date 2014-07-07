package com.touch.independent
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.net.XMLSocket;
	import flash.utils.setTimeout;
	
	/**
	 * TUIO 协议转换
	 * 将TUIO事件转换为 flash.events.TouchEvent
	 * TUIO协议标准 TUIO.org Ver 1.0
	 * @author IceFlame
	 */	
	public class TUIOTouchSupport extends EventDispatcher
	{
		//-------------------------------------------------------------------
		private static var _tuioSupport:TUIOTouchSupport;
		public static function get current():TUIOTouchSupport{
			if(_tuioSupport==null){
				_tuioSupport=new TUIOTouchSupport();
			}
			return _tuioSupport;
		}
		public static function init(_stage:Stage,_ip:String="127.0.0.1",_port:int=3000):void{
			current.init(_stage,_ip,_port);
		}
		//------------------------------------------------------
		
		private var _tuioSocket:XMLSocket;
		
		private var _host:String;
		
		private var _port:int;
		
		private var _stage:Stage;
		
		private var _stageWidth:int;
		
		private var _stageHeight:int;
		
		private var _touchList:Vector.<TuioObject>;
		
		
		/**
		 * TUIO协议转换
		 */
		public function TUIOTouchSupport()
		{
			super();
			_touchList=new Vector.<TuioObject>();
			
			_tuioSocket=new XMLSocket();
			_tuioSocket.addEventListener(Event.CONNECT,connectHandler);
			_tuioSocket.addEventListener(Event.CLOSE,closeHandler);
			_tuioSocket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			_tuioSocket.addEventListener(DataEvent.DATA,dataHandler);
		}
		
		/** 连接至TUIO 服务器 */
		public function init(stage:Stage,ip:String="127.0.0.1",port:int=3000):void{
			_host=ip;
			_port=port;
			_stage=stage;
			_stageWidth=stage.stageWidth;
			_stageHeight=stage.stageHeight;

			connect();
		}
		
		//开始连接
		private function connect():void{
			if(_tuioSocket.connected){
				return;
			}
			_tuioSocket.connect(_host,_port);
		}
		
		//连接关闭
		private function closeHandler(event:Event):void {
			setTimeout(connect,6000);
		}
		
		//连接成功
		private function connectHandler(event:Event):void {
		}
		
		//数据
		private function dataHandler(event:DataEvent):void {
			processMessage(XML(event.data));
		}
		
		//连接失败
		private function ioErrorHandler(event:IOErrorEvent):void {
			setTimeout(connect,6000);
		}
		
		//解析
		private function processMessage(msg:XML):void{
			//点是否存在  不存在则从列表中移除
			var node:XML;
			var touch:TuioObject;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0].@VALUE == "alive")
				{
					for each (touch in _touchList)touch.isExist=false;
					
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
			var touchObj:TuioObject;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.@NAME == "/tuio/2Dcur")
				{
					if(node.ARGUMENT[0].@VALUE == "set") 
					{
						remoteID = int(node.ARGUMENT[1].@VALUE);
						x = Number(node.ARGUMENT[2].@VALUE) * _stageWidth;
						y = Number(node.ARGUMENT[3].@VALUE) * _stageHeight;
						
						touchObj=searchByRemoteName(remoteID);
						if(!touchObj){
							var id:int = getFreeID();
							if(id == -1)return;
							touchObj = new TuioObject(id,x,y);
							touchObj.remoteID = remoteID;
							_touchList.push(touchObj);
							addTouch(touchObj);
						}else{
							touchObj.x = x ;touchObj.y = y;
							moveTouch(touchObj);
						}
					}
				}
			}
			
			//处理不存在的点
			for(var i:int=_touchList.length-1;i>=0;i--){
				if(!_touchList[i].isExist){
					removeTouch(_touchList[i]);
					_touchList.splice(i,1);
				}
			}
		}
		
		//根据远程触摸
		private function searchByRemoteName(remoteID:int):TuioObject{
			for each(var touch:TuioObject in _touchList){
				if(touch.remoteID == remoteID){
					return touch;
				}
			}
			return null;
		}
		
		//创建一个新点
		private function getFreeID():int{
			for(var i:int=256;i<1024;i++){
				var used:Boolean=false;
				for each(var temp:TuioObject in _touchList){
					used = i == temp.id;
				}
				if(!used)return i;
			}
			return 256;
		}
		
		//搜索舞台元素  
		private function findDisplayObject(x:Number,y:Number):InteractiveObject{
			var obj:DisplayObject;
			var objArray:Array = _stage.getObjectsUnderPoint(new Point(x,y));
			if(objArray.length>0){
				obj=objArray[objArray.length-1];
				if(!(obj is InteractiveObject)){
					obj=obj.parent;
				}
				return obj;
			}else{
				return _stage;
			}
		}
		
		
		//应用新的触摸点
		private function addTouch(touchPoint:TuioObject):void{
			touchPoint.target = findDisplayObject(touchPoint.x,touchPoint.y);
			if(touchPoint.target == _stage){
				_stage.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_BEGIN,
					true,false,touchPoint.id,false,touchPoint.x,touchPoint.y));
			}else{
				var local:Point = touchPoint.target.globalToLocal(new Point(touchPoint.x,touchPoint.y));
				touchPoint.target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_BEGIN,
					true,false,touchPoint.id,false,local.x,local.y));
			}
		}
		
		//触摸点移动
		private function moveTouch(touchPoint:TuioObject):void{
			var oldTarget:InteractiveObject = touchPoint.target;
			touchPoint.target = findDisplayObject(touchPoint.x,touchPoint.y);
			var local:Point = touchPoint.target.globalToLocal(new Point(touchPoint.x,touchPoint.y));
			if(touchPoint.target == oldTarget){
				oldTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_MOVE,
					true,false,touchPoint.id,false,local.x,local.y));
			}else{
				var old:Point = oldTarget.globalToLocal(new Point(touchPoint.x,touchPoint.y));
				oldTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_OUT,
					true,false,touchPoint.id,false,old.x,old.y,NaN,NaN,NaN,touchPoint.target));
				
				touchPoint.target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_OVER,
					true,false,touchPoint.id,false,local.x,local.y,NaN,NaN,NaN,touchPoint.target));
				touchPoint.target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_MOVE,
					true,false,touchPoint.id,false,local.x,local.y));
			}
		}
		
		//触摸点消失
		private function removeTouch(touchPoint:TuioObject):void{
			var oldTarget:InteractiveObject = touchPoint.target;
			touchPoint.target = findDisplayObject(touchPoint.x,touchPoint.y);
			var local:Point = touchPoint.target.globalToLocal(new Point(touchPoint.x,touchPoint.y));
			if(touchPoint.target == oldTarget){
				oldTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_END,
					true,false,touchPoint.id,false,local.x,local.y));
			}else{
				var old:Point = oldTarget.globalToLocal(new Point(touchPoint.x,touchPoint.y));
				oldTarget.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_OUT,
					true,false,touchPoint.id,false,old.x,old.y,NaN,NaN,NaN,touchPoint.target));
				
				touchPoint.target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_OVER,
					true,false,touchPoint.id,false,local.x,local.y,NaN,NaN,NaN,touchPoint.target));
				touchPoint.target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH_END,
					true,false,touchPoint.id,false,local.x,local.y));
			}
		}
	}
}