package game.logic
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	import com.touch.MultTouchPhase;
	
	import flash.events.Event;
	
	import game.ui.view.DScoreTypeViewUI;
	
	public class DScoreTypeView extends DScoreTypeViewUI
	{
		public function DScoreTypeView()
		{
			super();
			canBtn.addEventListener(MultTouchEvent.TOUCH,onTouch);
			new MultTouchHelper(canBtn,MultTouchHelper.SELECT);
			weiBtn.addEventListener(MultTouchEvent.TOUCH,onTouch);
			new MultTouchHelper(weiBtn,MultTouchHelper.SELECT);
			taiBtn.addEventListener(MultTouchEvent.TOUCH,onTouch);
			new MultTouchHelper(taiBtn,MultTouchHelper.SELECT);
		}
		
		private function onTouch(event:MultTouchEvent):void{
			if(event.touchType == MultTouchPhase.TOUCH_END){
				switch(event.currentTarget){
					case canBtn:
						trace("ddd")
						break;
					case taiBtn:
						trace("ddd2")
						break;
					case weiBtn:
						trace("ddd3")
						break;
				}
			
			}
		}
	}
}