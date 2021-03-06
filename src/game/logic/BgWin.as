package game.logic
{
	import com.data.DialogData;
	import com.evt.Dispatcher;
	import com.evt.GameEvent;
	
	import flash.events.Event;
	
	import game.ChooseCard;
	import game.ui.view.BgUI;
	
	import manager.ViewManager;
	
	import morn.core.components.Tab;
	import morn.core.events.UIEvent;
	
	public class BgWin extends BgUI
	{
		public function BgWin()
		{
			super();
			
			tab.addEventListener(Event.SELECT,tabBtnHandler);
			Dispatcher.me.addEventListener(GameEvent.LOGIN_BACK,loginBack);

		}
		
		private function loginBack(event:GameEvent):void{
			
		}
		
		private function tabBtnHandler(e:UIEvent):void
		{
			var tabSelected:int=(e.currentTarget as Tab).selectedIndex;
			var dialogdata:DialogData = new DialogData();
			switch(tabSelected){
				case 0:
					dialogdata.className = MainScreen;
					break;
				case 1:
					dialogdata.className = ControlScreen;
					break;
				case 2:
					dialogdata.className = DScoreTypeView;
					break;
				case 3:
//					dialogdata.className = SmoothDraw;
					dialogdata.className = ChooseCard;
					break;
				case 4:
					dialogdata.className = ZcrScreen;
					break;
			}
			ViewManager.me.setView(dialogdata);
		}
	}
}