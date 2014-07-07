package game.logic
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	
	import flash.display.Sprite;
	
	import game.ui.view.ControlScreenUI;
	
	public class ControlScreen extends ControlScreenUI
	{
		public function ControlScreen()
		{
			super();
			
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
	}
}