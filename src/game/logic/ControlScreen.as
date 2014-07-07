package game.logic
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import game.ui.view.ControlScreenUI;
	
	public class ControlScreen extends ControlScreenUI
	{
		private var sp:Sprite;
		public function ControlScreen()
		{
			super();
			sp = new Sprite()
			
			sp.graphics.beginFill(0x000ccc,1);
			sp.graphics.drawRect(-25,-25,50,50);
			sp.graphics.endFill();
			this.addChild(sp);
			
			sp.addEventListener(MultTouchEvent.GESTURE,testFun);
			
			// 5 - 检查Key
			new MultTouchHelper(sp,MultTouchHelper.MULT_ALL);
		}
		private function testFun(evt:MultTouchEvent):void{
			if(evt.touchPoint)
				var p:Point = sp.globalToLocal(new Point(evt.stageX,evt.stageY));

			sp.x += evt.moveX;
			sp.y += evt.moveY;
			sp.scaleX = sp.scaleY *= evt.scale;
			
			sp.rotation += evt.rota;
		}
	}
}