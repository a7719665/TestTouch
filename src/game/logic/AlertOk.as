package game.logic
{
	import flash.events.MouseEvent;
	
	import game.ui.view.AlertOkUI;
	
	import manager.IAlert;
	
	public class AlertOk extends AlertOkUI implements IAlert 
	{
		public function AlertOk()
		{
			super();
			addEL(confirmBtn,MouseEvent.CLICK,close);
		}
		
		private function setTxt($word:String):void{
			txt.text = $word;
		}
		
		public function init(args:Array):void{
			setTxt(args[0]);
		}
		
		override public function destroy():void{
//			super.destroy();
		}
		
	}
}