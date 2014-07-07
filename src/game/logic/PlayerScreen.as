package game.logic
{
	import com.data.GridVO;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	import com.touch.MultTouchPhase;
	import com.transformer.ByteArrayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import game.ui.view.PlayerScreenUI;
	
	import manager.AlertManager;
	
	import utils.TimerFormat;
	import utils.TimerUtils;
	
	public class PlayerScreen extends PlayerScreenUI
	{
		private var smoothDraw:SmoothDraw;
		private var rect:Rectangle ;
		private var timer:TimerUtils;
		public function PlayerScreen()
		{
			super();
			trapezoid = new Sprite();   
			this.addChild(trapezoid);
//			trapezoid.x = drawSp.x;
//			trapezoid.y = drawSp.y;
			
			trapezoid.graphics.beginFill(0xFFD700,0);
			
			trapezoid.graphics.drawRect(drawSp.x,drawSp.y,drawSp.width,drawSp.height);
			
			trapezoid.graphics.endFill();
			
			rect = new Rectangle(drawSp.x,drawSp.y,drawSp.width,drawSp.height);
			
//			startDraw();
			
			conmitBtn.addEventListener(MouseEvent.MOUSE_DOWN,saveByte);
			playerMain.visible=false;
			card.visible=true;
			
			
			card.addEventListener(MultTouchEvent.GESTURE,scaleHandle);
			
			// 5 - 检查Key
			new MultTouchHelper(card,MultTouchHelper.MULT_ALL);
			
			
			trapezoid.addEventListener(MultTouchEvent.TOUCH,testFun);
			new MultTouchHelper(trapezoid,MultTouchHelper.MULT_ALL);
			
			setTimer();
			setList();
		}
		
		private function setList():void{
			var listData:Array=[];
			var arr:Array = Global.question;
			var arr2:Array = Global.answer;
			if(arr.length != arr2.length){
				AlertManager.showByName(AlertOk,null,"answer和question数组不一样");
			}else{
				for(var i:int=0;i<arr.length;i++){
					var gridvo:GridVO = new GridVO();
					gridvo.question = arr[i];
					gridvo.answer = arr2[i];
					listData.push(gridvo);
				}
			}
			grid.setList(listData) ;
		}
		
		private function setTimer():void{
			timer = new TimerUtils(1000,10);
			timer.registerCallback(progressHandle,completeHandle);
			timer.start();
		}
		private function progressHandle():void{
			timeTxt2.text = TimerFormat.setTimeText(timer.repeatCount-timer.currentCount);
		}
		private function completeHandle():void{
		}
		
		private function testFun(evt:MultTouchEvent):void{
			var p:Point = trapezoid.globalToLocal(new Point(evt.stageX,evt.stageY));
			if(!rect.contains(p.x,p.y)){
				trapezoid.graphics.endFill();
				return;
			}
			if(evt.touchType == MultTouchPhase.TOUCH_BEGAN){
				trapezoid.graphics.lineStyle(4, 0xFFFFFF, 1, false, LineScaleMode.VERTICAL,
					CapsStyle.NONE, JointStyle.MITER, 10);
				/**将起点移到鼠标点击点处*/
				trapezoid.graphics.moveTo(p.x,p.y);
			}
			if(evt.touchType == MultTouchPhase.TOUCH_MOVE){
				trapezoid.graphics.lineTo(p.x,p.y);
			}
			if(evt.touchType == MultTouchPhase.TOUCH_END){
				trapezoid.graphics.endFill();
			}
		}
		
		private function scaleHandle(evt:MultTouchEvent):void{
			playerMain.visible=true;
			card.visible=false;
			trace(evt.scale);
			if(evt.scale>1){
				card.scale = evt.scale;
				if(card.scale >=1.03){
					playerMain.visible=true;
					card.visible=false;
				}
			}
		}
		
		private const CLEAR:Boolean = false;//是否每一次画线前都清内容
		private var trapezoid:Sprite ;
		private var bmdbytes:ByteArray;
		private function huanyuanBmd(evt:Event=null):void{
			var bmd:BitmapData = ByteArrayUtil.BytesToBitmapData(bmdbytes);
			
			var bmp:Bitmap = new Bitmap(bmd);
			this.addChild(bmp);
			bmp.x = trapezoid.x +200;
		}
		private function saveByte(evt:Event=null):void{
			trapezoid.graphics.endFill();
			var rect:Rectangle = trapezoid.getBounds(this);
			
			var m:Matrix = trapezoid.transform.matrix;
			m.tx -= rect.x;
			m.ty -= rect.y;//这里很重要，解释一下，因为lingto画出来的东西，它的x y坐标是第一个lineto指向的坐标
			
			var bmd:BitmapData=new BitmapData(rect.width,rect.height,true, 0);  
			bmd.draw(trapezoid,m);
			
			var bmp:Bitmap = new Bitmap(bmd);
			this.addChild(bmp);
			bmp.x = 100;
						
			bmdbytes = ByteArrayUtil.BitmapDataToBytes(bmp.bitmapData);
		}
		
		
	}
}