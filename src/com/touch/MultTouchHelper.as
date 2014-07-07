package com.touch
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 多点辅助工具
	 * @author IceFlame
	 */	
	public class MultTouchHelper
	{
		//------------------------------------------------------------
		/** 单选 */
		public static const SELECT:int = 0;
		
		/** 位移 */
		public static const DISPLACEMENT:int=1;
		
		/** 位移 + 放大 */
		public static const MULT_SCALE:int=2;
		
		/** 位移 + 放大 + 旋转 */
		public static const MULT_ALL:int=3;
		//------------------------------------------------------------
		
		private const TO_ROT:Number =57.29577951308232;// 180/Math.PI
		
		private var _mode:int;
		
		private var _target:InteractiveObject;
		
		private var _touchList:Vector.<MultTouchPoint>;
		
		/** 多点辅助工具 */
		public function MultTouchHelper(obj:InteractiveObject,mode:int)
		{
			_mode = mode;
			_target = obj;
			_touchList = new Vector.<MultTouchPoint>();
			touchEnable = true;
		}
		
		/** 是否启用触摸 */
		public function set touchEnable(value:Boolean):void{
			if(value){
				_target.addEventListener(MultTouchEvent.TOUCH,onTouch);
			}else{
				_target.removeEventListener(MultTouchEvent.TOUCH,onTouch);
			}
		}
		
		/** 是否接受悬停事件 【暂不支持】 */
		public function set hoverEnable(value:Boolean):void{
			if(value){
				
			}else{
				
			}
		}
		
		//触摸操作
		private function onTouch(event:MultTouchEvent):void{
			var touch:MultTouchPoint = event.touchPoint;
			if(event.touchType == MultTouchPhase.TOUCH_BEGAN){
				_touchList.push(touch);
			}else if(event.touchType == MultTouchPhase.TOUCH_END){
				for(var i:int = _touchList.length - 1 ; i >= 0 ; i--){
					if(touch == _touchList[i])_touchList.splice(i,1);
				}
				if(getTimer() - touch.startTime < 500 && _touchList.length == 0 &&
					Math.round(touch.startX - touch.x) < 10 && 
					Math.round(touch.startY - touch.y) < 10){
					_target.dispatchEvent(new MultTouchEvent(MultTouchEvent.SELECT));
				}
			}else if(event.touchType == MultTouchPhase.TOUCH_MOVE){
				if(_mode != SELECT)onUpData();
			}
		}
		
		//执行缩放旋转
		private function onUpData():void{
			if(_touchList.length<1){
				return;
			}
			var event:MultTouchEvent = new MultTouchEvent(MultTouchEvent.GESTURE);
			if(_touchList.length==1){
				event.moveX = _touchList[0].x-_touchList[0].oldX;
				event.moveY = _touchList[0].y-_touchList[0].oldY;
				_touchList[0].oldX = _touchList[0].x;
				_touchList[0].oldY = _touchList[0].y;
				event.scale = 1;event.rota = 0;
			}else{
				var newPoint0:Point=new Point(_touchList[0].x,_touchList[0].y);
				var newPoint1:Point=new Point(_touchList[1].x,_touchList[1].y);
				var oldPoint0:Point=new Point(_touchList[0].oldX,_touchList[0].oldY);
				var oldPoint1:Point=new Point(_touchList[1].oldX,_touchList[1].oldY);
				
				_touchList[0].oldX = _touchList[0].x
				_touchList[0].oldY = _touchList[0].y;
				_touchList[1].oldX = _touchList[1].x
				_touchList[1].oldY = _touchList[1].y;
				
				var newCenter:Point=Point.interpolate(newPoint0,newPoint1, 0.5);
				var oldCenter:Point=Point.interpolate(oldPoint0,oldPoint1, 0.5);
				event.moveX = newCenter.x - oldCenter.x;
				event.moveY = newCenter.y - oldCenter.y;
				
				if(_mode >= MULT_SCALE){
					event.scale = Point.distance(newPoint0,newPoint1)/Point.distance(oldPoint0,oldPoint1);
				}else{
					event.scale = 1;
				}
				
				if(_mode >= MULT_ALL){
					event.rota = getAngle(newPoint0,newPoint1)-getAngle(oldPoint0,oldPoint1);
				}else{
					event.rota = 0;
				}
			}
			_target.dispatchEvent(event);
		}
		
		//角度值计算
		private function getAngle(p1:Point,p2:Point):Number{
			var ang:Point=p2.subtract(p1);
			return Math.atan2(ang.y,ang.x) * TO_ROT;
		}
	}
}