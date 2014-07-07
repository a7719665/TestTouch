package game.logic
{
	import com.data.GridVO;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	import com.touch.MultTouchPhase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.ui.view.ZcrScreenUI;
	
	import manager.AlertManager;
	
	import utils.ColorTextUtils;
	import utils.TimerFormat;
	import utils.TimerUtils;
	
	public class ZcrScreen extends ZcrScreenUI
	{
		private var timer:TimerUtils;

		public function ZcrScreen()
		{
			super();
			setLeftTxt();
			setRightTxt();
			setList();
			setTimer();
			
			setTips();
			
			showAnser.addEventListener(MultTouchEvent.TOUCH,showAnswer);
			drawSp.addEventListener(MultTouchEvent.TOUCH,testFun);
			new MultTouchHelper(drawSp,MultTouchHelper.MULT_ALL);
			new MultTouchHelper(showAnser,MultTouchHelper.MULT_ALL);

			function testFun(evt:MultTouchEvent):void{
				//				sp.x += evt.moveX;
				//				sp.y += evt.moveY;
				//				sp.scaleX = sp.scaleY *= evt.scale;
				//				
				//				sp.rotation += evt.rota;
				if(evt.touchType == MultTouchPhase.TOUCH_BEGAN){
					drawSp.graphics.lineStyle(4, 0xFFFFFF, 1, false, LineScaleMode.VERTICAL,
						CapsStyle.NONE, JointStyle.MITER, 10);
					/**将起点移到鼠标点击点处*/
					drawSp.graphics.moveTo(evt.stageX,evt.stageY);
				}
				if(evt.touchType == MultTouchPhase.TOUCH_MOVE){
					drawSp.graphics.lineTo(evt.stageX,evt.stageY);
				}
				if(evt.touchType == MultTouchPhase.TOUCH_END){
					drawSp.graphics.endFill();
				}
			}
		}
		
		private function showAnswer(evt:MultTouchEvent):void{
			grid.showSelectAnswer();
		}
		private function saveByte(evt:Event=null):void{
			drawSp.graphics.endFill();
			var rect:Rectangle = drawSp.getBounds(this);
			var bmd:BitmapData=new BitmapData(rect.width,rect.height,true, 0);  
			bmd.draw(drawSp );
			//			var bytes:ByteArray = ByteArrayUtil.BitmapDataToBytes(bmd);
			
			var bmp:Bitmap = new Bitmap(bmd);
			this.addChild(bmp);
			bmp.x = drawSp.x +100;
			
			
		}
		
		private function setLeftTxt():void{
			var str:String="";
			var arr:Array = Global.heng;
			for(var i:int=0;i<arr.length;i++){
				str += (ColorTextUtils.setColorFont(arr[i],ColorTextUtils.normalS)+"<br>");
			}
			leftTxt.text=str;
		}
		private function setRightTxt():void{
			var str:String="";
			var arr:Array = Global.zhong;
			
			for(var i:int=0;i<arr.length;i++){
				str += (ColorTextUtils.setColorFont(arr[i],ColorTextUtils.normalS)+"<br>");
			}
			rightTxt.text=str;
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
			timer = new TimerUtils(1000,5);
			timer.registerCallback(progressHandle,completeHandle);
			timer.start();
		}
		private function progressHandle():void{
			timeTxt1.text = TimerFormat.setTimeText(timer.repeatCount-timer.currentCount);
			timeTxt2.text = TimerFormat.setTimeText(timer.repeatCount-timer.currentCount);
		}
		private function completeHandle():void{
		}
		
		private function setTips():void{
//			tipTxt.text = Global.heng[0];
		}
	}
}