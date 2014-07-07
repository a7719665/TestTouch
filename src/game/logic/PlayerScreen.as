package game.logic
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
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
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import game.ui.view.PlayerScreenUI;
	
	public class PlayerScreen extends PlayerScreenUI
	{
		private var smoothDraw:SmoothDraw;
		public function PlayerScreen()
		{
			super();
			trapezoid = new Shape();   
			this.addChild(trapezoid);
//			trapezoid.graphics.beginFill(0xFFD700,0);
//			
//			trapezoid.graphics.drawCircle(0,0,1);
//			
//			trapezoid.graphics.endFill();
			
//			startDraw();
			
//			qiangBtn.addEventListener(MouseEvent.MOUSE_DOWN,saveByte);
			conmitBtn.addEventListener(MouseEvent.MOUSE_DOWN,huanyuanBmd);
			playerMain.visible=false;
			card.visible=true;
			
//			smoothDraw = new SmoothDraw();
//			this.addChild(smoothDraw);
//			smoothDraw.x = drawSp.x;
//			smoothDraw.y = drawSp.y;
			
			card.addEventListener(MultTouchEvent.GESTURE,scaleHandle);
//			card.addEventListener(MultTouchEvent.SELECT,scaleHandle);
			
			// 5 - 检查Key
			new MultTouchHelper(card,MultTouchHelper.MULT_ALL);
		}
		
		private function scaleHandle(evt:MultTouchEvent):void{
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
		private var trapezoid:Shape ;
		private function startDraw():void{
			drawSp.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownFun);
			
		}
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
		
		
		/**鼠标按下*/
		private function mouseDownFun(e:MouseEvent):void{
			if(CLEAR){
				this.graphics.clear();
			}
			trapezoid.graphics.lineStyle(4, 0xFFD700, 1, false, LineScaleMode.VERTICAL,
				CapsStyle.NONE, JointStyle.MITER, 10);
			/**将起点移到鼠标点击点处*/
			trapezoid.graphics.moveTo(mouseX,mouseY);
			
			/**添加鼠标移动事件，和鼠标释放事件*/
			drawSp.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveFun);
			drawSp.addEventListener(MouseEvent.MOUSE_UP,mouseUpFun);
			drawSp.addEventListener(MouseEvent.MOUSE_OUT,mouseUpFun);
		}
		
		/**鼠标移动，开始画线*/
		private function mouseMoveFun(e:MouseEvent):void{
			trapezoid.graphics.lineTo(mouseX,mouseY);
		}
		
		/**鼠标释放，移除事件，停止画线*/
		private function mouseUpFun(e:MouseEvent):void{
			drawSp.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveFun);
			drawSp.removeEventListener(MouseEvent.MOUSE_UP,mouseUpFun);
			drawSp.removeEventListener(MouseEvent.MOUSE_OUT,mouseUpFun);
			trapezoid.graphics.endFill();
//			saveByte();
		}
	}
}