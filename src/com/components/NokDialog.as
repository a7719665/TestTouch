package com.components
{
	
	import com.data.DialogData;
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import manager.IAlert;
	import manager.LayerManager;
	
	import morn.core.components.Dialog;
	import morn.core.utils.StringUtils;
	
	public class NokDialog extends Dialog 
	{
		private var _dialogData:DialogData;
		public function NokDialog()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removeStageHandle);
		}
		
		private var listenArr:Array = [];
		/**一些事件的监听，统一写到这里*/
		public function addEL(dis:IEventDispatcher,event:String,ListenHandle:Function,useca:Boolean=false):void{
			var obj:Object = {dis:dis,event:event,call:ListenHandle};
			listenArr.push(obj);
			dis.addEventListener(event,ListenHandle,useca);
		}
		
		/**一些事件的监听，统一移除*/
		public function removeEL():void{
			for(var i:int=0;i<listenArr.length;i++){
				var dis:IEventDispatcher = listenArr[i].dis;
				dis.removeEventListener(listenArr[i].event,listenArr[i].call);
			}
		}
		
		public function get dialogData():DialogData
		{
			return _dialogData;
		}

		public function set dialogData(value:DialogData):void
		{
			_dialogData = value;
			this.name = value.winName;
		}

		override public function set dragArea(value:String):void {
			if (Boolean(value)) {
				var a:Array = StringUtils.fillArray([0, 0, 0, 0], value);
				_dragArea = new Rectangle(a[0], a[1], a[2], a[3]);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
 			} else {
				_dragArea = null;
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		
		override public function close(type:String=null):void{
			if(this is IAlert){
				removeself();
			}else{
				LayerManager.me.removeDynamicWindow(dialogData.winName);
				
				LayerManager.me.displayAllWindowByType();
	
//				var img:View = GameGlobal.bottomView.getBtnByName(this.dialogData.winName);
//				if(img){
//					var rect:Rectangle = img.getRect(this.parent);
//					TweenLite.to(this, 0.5, {x:rect.x, y:rect.y, scaleX:0, scaleY:0,onComplete:removeself});
//				}else{
					removeself();
//				}
			}
		}
		
		
		
		/**关闭对话框*/
		public function removeself():void {
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if(parent.getChildAt(parent.numChildren-1) != this)
				parent.setChildIndex(this,parent.numChildren-1);
			if (_dragArea.contains(mouseX, mouseY)) {
//				App.drag.doDrag(this);
				this.addEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
				this.addEventListener(Event.MOUSE_LEAVE,stageMouseUpHandler);

				startDrag(false,new Rectangle(0,0,Global.W - this.width,Global.H - this.height));

			}
		}
		
		private function stageMouseUpHandler(evt:Event):void{
			if(stage) {
				this.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
				this.removeEventListener(Event.MOUSE_LEAVE,stageMouseUpHandler);
			}
			stopDrag();
		}
		
		public function onAddedToStage(e:Event=null):void{
			this.alpha = 0;
			TweenMax.to(this,0.3,{alpha:1});
		}
		
		private function removeStageHandle(e:Event):void{
			destroy();
		}
		
		public function destroy():void{
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEL();
			listenArr.length=0;
			listenArr = null;
		}
		
	}
}