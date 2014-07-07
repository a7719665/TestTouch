package game.logic
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.view.PlayerAPanelUI;
	
	import utils.TimerFormat;
	import utils.TimerUtils;
	
	public class PlayerAPanel extends PlayerAPanelUI
	{
		private var allTimer:TimerUtils;
		private var oneTimer:TimerUtils;
		public function PlayerAPanel()
		{
			super();
			
			allTimer = new TimerUtils(1000,300);
			allTimer.registerCallback(allprogressHandle,allcompleteHandle);
			allTimer.start();
			
			oneTimer = new TimerUtils(1000,30);
			oneTimer.registerCallback(oneprogressHandle,onecompleteHandle);
			oneTimer.start();
			
			
			onebtn.addEventListener(MouseEvent.CLICK,stopOneTimer);
			allbtn.addEventListener(MouseEvent.CLICK,stopAllTimer);
		}
		
		public function stopAllTimer(evt:Event):void{
			if(allTimer.isRunning())
				allTimer.stop();
			else
				allTimer.restart();
		}
		public function stopOneTimer(evt:Event):void{
			if(oneTimer.isRunning())
				oneTimer.stop();
			else
				oneTimer.restart();
		}
		
		private function allprogressHandle():void{
			allTimeTxt.text = TimerFormat.setTimeText(allTimer.repeatCount-allTimer.currentCount);
		}
		private function allcompleteHandle():void{
			
		}
		
		private function oneprogressHandle():void{
			oneTimerTxt.text = TimerFormat.setTimeText(oneTimer.repeatCount-oneTimer.currentCount);
		}
		private function onecompleteHandle():void{
			
		}
		
		public function setScore(value:int):void{
			scoreTxt.text = value.toString();
		}
	}
}