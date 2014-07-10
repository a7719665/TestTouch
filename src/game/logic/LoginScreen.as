package game.logic
{
	import com.evt.Dispatcher;
	import com.evt.GameEvent;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	import com.touch.MultTouchPhase;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.ui.view.LoginScreenUI;
	
	import morn.core.components.Button;
	import morn.core.components.TextInput;
	
	import net.DataPacket;
	import net.DataPacketResult;
	import net.EPSocket;
	
	public class LoginScreen extends LoginScreenUI
	{
		public function LoginScreen()
		{
			super();
			
			iptxt.addEventListener(FocusEvent.FOCUS_IN,ipFocusHandle);
			porttxt.addEventListener(FocusEvent.FOCUS_IN,portFocusHandle);
			for(var i:int=0;i<12;i++){
				this["btn"+i].addEventListener(MultTouchEvent.SELECT,onTouch);
//				new MultTouchHelper(this["btn"+i],MultTouchHelper.MULT_ALL);

//				this["btn"+i].addEventListener(MouseEvent.CLICK,onTouch);
			}
			loginBtn.addEventListener(MultTouchEvent.SELECT,loginClick);
			Dispatcher.me.addEventListener("401",loginBack);

		}
		
		private var currentFocus:TextInput;
		private function ipFocusHandle(event:Event):void{
			currentFocus = iptxt;
			
		}
		
		private function loginBack(event:GameEvent):void{
			var acid:int = event.data.actionId;
			var d:DataPacket = event.data.dataPacket;
			if(d.result == DataPacketResult.SUCC){
				Dispatcher.me.dispatchEvent(new GameEvent(GameEvent.LOGIN_BACK));

			}
		}
		
		private function portFocusHandle(event:Event):void{
			currentFocus = porttxt;
		}
		private function loginClick(event:Event):void{
			EPSocket.me.sendData(401);
		}
		private function onTouch(event:Event):void{
			if(!currentFocus)
				return;
			var target:Button = event.currentTarget as Button;
			var ii:String = target.name.slice(3);
			if(ii =="11" ){
				currentFocus.text = currentFocus.text.slice(0,currentFocus.text.length-1);
			}else if( ii =="10" ){
				currentFocus.text += ".";
			}else{
				currentFocus.text += ii;
			}
		}
	}
}