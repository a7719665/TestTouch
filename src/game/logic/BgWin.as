package game.logic
{
	import com.data.DialogData;
	
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
					dialogdata.className = PlayerScreen;
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