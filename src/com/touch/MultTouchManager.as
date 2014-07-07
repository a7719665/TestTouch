package com.touch
{
	import com.touch.extension.ITouchModule;
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	/**
	 * 触摸管理器 2.0  
	 * 可以接收TUIO协议与远程触摸协议
	 * 将触摸事件转换为轻量事件
	 * @author IceFlame
	 */	
	public class MultTouchManager
	{
		//-----------------------------------------------------------------
		private static var _current:MultTouchManager;
		
		/** 全局唯一的触摸管理器  */
		public static function get current():MultTouchManager{
			if(!_current){
				_current = new MultTouchManager();
			}
			return _current;
		}
		//-----------------------------------------------------------------
		public static const TOUCH_BEGIN:int = 1;
		
		public static const TOUCH_MOVE:int = 2;
		
		public static const TOUCH_END:int = 3;
		
		private var _stage:Stage;
		
		private var _mousePoint:MultTouchPoint;
		
		private var _touchPoint:Vector.<MultTouchPoint>;
		
		private var _moduleList:Vector.<ITouchModule>;
		
		/** 触摸管理器 */
		public function MultTouchManager()
		{
			if(_current) {
				throw new Error("全局只能存在一个触摸管理器"); 
			}else{
				_current = this;
			}
			_touchPoint = new Vector.<MultTouchPoint>();
			_moduleList = new Vector.<ITouchModule>();
		}
		
		/** 初始化 */
		public function init(stage:Stage):void{
			_stage = stage;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_stage.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchOn,true);
			_stage.addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove,true);
			_stage.addEventListener(TouchEvent.TOUCH_END,onTouchEnd,true);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,true);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true);
		}
		
		/** 释放空间 */
		public function dispose():void{
			_stage.removeEventListener(TouchEvent.TOUCH_BEGIN,onTouchOn,true);
			_stage.removeEventListener(TouchEvent.TOUCH_MOVE,onTouchMove,true);
			_stage.removeEventListener(TouchEvent.TOUCH_END,onTouchEnd,true);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,true);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp,true);
			while(_touchPoint.length > 0){
				_touchPoint.shift().dispose();
			}
			while(_moduleList.length > 0){
				_moduleList.shift().dispose();
			}
			if(_mousePoint)_mousePoint.dispose();
			_stage = null;
		}
		
		/** 搜索触摸点 */
		public function findTouchPoint(id:int):MultTouchPoint{
			if(id == -1)return _mousePoint;
			var touch:MultTouchPoint = searchLocalPoint(id);
			if(touch)return touch;
			return searchRemotePoint(id);
		}
		
		/** 插入Module */
		public function addModule(module:ITouchModule):void{
			_moduleList.push(module);
			module.init(_stage.stageWidth,_stage.stageHeight);
			module.addEventListener(TouchModuleEvent.REMOTE_CHANGE,applyRemote)
		}
		
		/** 移除Module */
		public function removeModule(module:ITouchModule):void{
			module.removeEventListener(TouchModuleEvent.REMOTE_CHANGE,applyRemote)
			var len:int = _moduleList.length;
			for(var i:int = 0 ; i < len ; i ++){
				if(_moduleList[i] == module){
					_moduleList.splice(i,1);
					return;
				}
			}
		}

		// 应用一个远程触摸操作
		private function applyRemote(event:TouchModuleEvent):void{
			var changeList:Vector.<MultTouchPoint> = event.touchList;
			for each(var touch:MultTouchPoint in changeList){
				if(touch.id == 0){
					touch.id = getFreeRemoteID();
					addTouch(touch);
				}else if(!touch.isExist){
					removeTouch(touch);
				}else if(touch.target){
					moveTouch(touch);
				}
			}
		}
		
		// 搜索远程触摸点 
		private function searchRemotePoint(id:int):MultTouchPoint{
			var touch:MultTouchPoint;
			for each(var module:ITouchModule in _moduleList){
				touch = module.getTouch(id);
				if(touch)return touch;
			}
			return null;
		}
		
		// 搜索本地触摸点
		public function searchLocalPoint(id:int):MultTouchPoint{
			for each(var touch:MultTouchPoint in _touchPoint){
				if(touch.id == id)return touch;
			}
			return null;
		}
		
		//应用新的触摸点
		private function addTouch(touchPoint:MultTouchPoint):void{
			touchPoint.startTarget = touchPoint.target = findDisplayObject(touchPoint.x,touchPoint.y);
			touchPoint.target.dispatchEvent(new MultTouchEvent(
				MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_BEGAN,touchPoint));
		}
		
		//触摸点移动
		private function moveTouch(touchPoint:MultTouchPoint):void{
			var oldTarget:InteractiveObject = touchPoint.target;
			touchPoint.target = findDisplayObject(touchPoint.x,touchPoint.y);
			if(touchPoint.target == oldTarget){
				oldTarget.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_MOVE,touchPoint));
			}else{
				oldTarget.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_OUT,touchPoint));
				
				touchPoint.target.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_OVER,touchPoint));
				touchPoint.target.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_MOVE,touchPoint));
			}
			if(touchPoint.startTarget != touchPoint.target){
				touchPoint.startTarget.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_MOVE,touchPoint));
			}
		}
		
		//触摸点消失
		private function removeTouch(touchPoint:MultTouchPoint):void{
			var oldTarget:InteractiveObject = touchPoint.target;
			touchPoint.target = findDisplayObject(touchPoint.x,touchPoint.y);
			if(touchPoint.target == oldTarget){
				oldTarget.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_END,touchPoint));
			}else{
				oldTarget.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_OUT,touchPoint));
				
				touchPoint.target.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_OVER,touchPoint));
				touchPoint.target.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_END,touchPoint));
			}
			if(touchPoint.startTarget != touchPoint.target){
				touchPoint.startTarget.dispatchEvent(new MultTouchEvent(
					MultTouchEvent.TOUCH,true,MultTouchPhase.TOUCH_END,touchPoint));
			}
		}
		
		// 查找ID
		private function getFreeRemoteID():int{
			var isUsed:Boolean;
			for(var i:int = 256 ; i <1024 ; i ++ ){
				isUsed = false;
				for each(var module:ITouchModule in _moduleList){
					if( module.getTouch(i)){
						isUsed = true;
						break;
					}
				}
				if(!isUsed)return i;
			}
			return 256;
		}
		
		//搜索舞台元素  
		private function findDisplayObject(x:Number,y:Number):InteractiveObject{
			var obj:InteractiveObject;
			var objArray:Array = _stage.getObjectsUnderPoint(new Point(x,y));
			for(var i:int=objArray.length-1; i >= 0 ;i--){
				if(objArray[i] is InteractiveObject){
					obj = objArray[i];
				}else{
					obj=objArray[i].parent;
				}
				if(obj.mouseEnabled){
					break;
				}
				obj = null
			}
			if(obj)return obj;
			return _stage;
		}
		
		//触摸事件
		private function onTouchOn(event:TouchEvent):void{
			event.stopImmediatePropagation();
			if(event.isPrimaryTouchPoint) {
				return;
			}
			var touch:MultTouchPoint =searchLocalPoint(event.touchPointID);
			if(!touch){
				touch = new MultTouchPoint(event.touchPointID,event.sizeX,event.stageY);
				_touchPoint.push(touch);
				addTouch(touch);
			}else{
				moveTouch(touch);
			}
		}
		private function onTouchMove(event:TouchEvent):void{
			event.stopImmediatePropagation();
			if(event.isPrimaryTouchPoint){
				return;
			}
			var touch:MultTouchPoint =searchLocalPoint(event.touchPointID);
			if(touch){
				touch.updata(event.stageX,event.stageY);
				moveTouch(touch);
			}
		}
		private function onTouchEnd(event:TouchEvent):void{
			event.stopImmediatePropagation();
			if(event.isPrimaryTouchPoint){
				return;
			}
			var len:int = _touchPoint.length;
			for(var i:int = i ; i < len ; i ++){
				if(_touchPoint[i].id == event.touchPointID){
					_touchPoint[i].updata(event.stageX,event.stageY);
					removeTouch(_touchPoint[i]);
					_touchPoint.splice(i,1);
					return;
				}
			}
		}
		//鼠标事件
		private function onMouseDown(event:MouseEvent):void{
			event.stopImmediatePropagation();
			if(!_mousePoint){
				_mousePoint = new MultTouchPoint(-1,event.stageX,event.stageY);
				addTouch(_mousePoint);
			}
		}
		private function onMouseMove(event:MouseEvent):void{
			event.stopImmediatePropagation();
			if(_mousePoint){
				_mousePoint.updata(event.stageX,event.stageY);
				moveTouch(_mousePoint);
			}
		}
		private function onMouseUp(event:MouseEvent):void{
			event.stopImmediatePropagation();
			if(_mousePoint){
				_mousePoint.updata(event.stageX,event.stageY);
				removeTouch(_mousePoint);
				_mousePoint = null;
			}
		}
	}
}