package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class TestDraw extends Sprite
	{
		public function TestDraw()
		{
			super();
			trapezoid = new Shape();   
			this.addChild(trapezoid);
//			trapezoid.graphics.beginFill(0xcc,0);
			
//			trapezoid.graphics.drawCircle(50,50,50);
			
//			trapezoid.graphics.endFill();
			startDraw();
		}
		
		private const CLEAR:Boolean = false;//是否每一次画线前都清内容
		private var trapezoid:Shape ;
		private function startDraw():void{
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownFun);
			
		}
		
		private function saveByte(evt:Event=null):void{
			trapezoid.graphics.endFill();
			var rect:Rectangle = trapezoid.getBounds(this);
			var bmd:BitmapData=new BitmapData(rect.width,rect.height,true, 0);  
			bmd.draw(trapezoid );
			//			var bytes:ByteArray = ByteArrayUtil.BitmapDataToBytes(bmd);
			
			var bmp:Bitmap = new Bitmap(bmd);
			this.addChild(bmp);
			bmp.x = trapezoid.x +100;
			
			
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
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveFun);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpFun);
			this.stage.addEventListener(MouseEvent.MOUSE_OUT,mouseUpFun);
		}
		
		/**鼠标移动，开始画线*/
		private function mouseMoveFun(e:MouseEvent):void{
			trapezoid.graphics.lineTo(mouseX,mouseY);
		}
		
		/**鼠标释放，移除事件，停止画线*/
		private function mouseUpFun(e:MouseEvent):void{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveFun);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpFun);
			this.stage.removeEventListener(MouseEvent.MOUSE_OUT,mouseUpFun);
			
			saveByte();
		}
	}
}