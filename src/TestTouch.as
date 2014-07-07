package
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	import com.touch.MultTouchManager;
	import com.touch.extension.TuioModule;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class TestTouch extends Sprite
	{
		public function TestTouch()
		{
			MultTouchManager.current.init(stage);
			
			var _tuioModule:TuioModule = new TuioModule();
			MultTouchManager.current.addModule(_tuioModule);
			_tuioModule.setHost();
			
			
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000ccc,1);
			sp.graphics.drawRect(-25,-25,50,50);
			sp.graphics.endFill();
			this.addChild(sp);
			
			sp.addEventListener(MultTouchEvent.GESTURE,testFun);
			
			function testFun(evt:MultTouchEvent):void{
				sp.x += evt.moveX;
				sp.y += evt.moveY;
				sp.scaleX = sp.scaleY *= evt.scale;
				
				sp.rotation += evt.rota;
			}
			// 5 - 检查Key
			new MultTouchHelper(sp,MultTouchHelper.MULT_ALL);
		}
		private var a:Sprite;
		private var trapezoid:Shape ;
	}
	

}