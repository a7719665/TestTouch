package game.logic
{
	import com.gs.TweenLite;
	
	import flash.events.Event;
	import flash.utils.clearTimeout;
	
	import game.ui.view.AlertFloatUI;
	
	import manager.IAlert;
	
	import morn.core.managers.TimerManager;
	
	public class AlertFloat extends AlertFloatUI implements IAlert 
	{
		private var timeId:int;
		public function AlertFloat()
		{
			super();
//			timeId = setTimeout(tweenClick,3000,);
		}
		
		override public function onAddedToStage(e:Event=null):void{
			super.onAddedToStage();
			App.timer.doLoop(1000,changeTxt);
		}
		
		private var dd:int;
		private function changeTxt():void{
			dd++;
			var t:TimerManager = App.timer;
			autoTxt.text = (3-dd)+"s后自动消失" ;
			if(dd == 3){
				tweenClick();
				t.clearTimer(changeTxt);
				dd = 0;
			}
		}
		
		public function init(arg:Array):void{
			setTxt(arg[0]);
		}
		
		private function setTxt($word:String):void{
			txt.text = $word;
		}
		
		private function tweenClick():void{
			clearTimeout(timeId);

			TweenLite.to(this,0.6,{y:this.y-100,alpha:0,onComplete:remove2});
		}
		
		public function remove2():void{
			this.parent.removeChild(this);
		}
		/**这里必须覆盖，不然addtostage方法就没了*/
		override public function destroy():void{
//			super.destroy();
		}
		
	}
}
