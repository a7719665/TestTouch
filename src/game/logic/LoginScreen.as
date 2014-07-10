package game.logic
{
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.ui.view.LoginScreenUI;
	
	import morn.core.components.Button;
	import morn.core.components.TextInput;
	
	public class LoginScreen extends LoginScreenUI
	{
		public function LoginScreen()
		{
			super();
			
			iptxt.addEventListener(FocusEvent.FOCUS_IN,ipFocusHandle);
			porttxt.addEventListener(FocusEvent.FOCUS_IN,portFocusHandle);
			for(var i:int=0;i<12;i++){
				this["btn"+i].addEventListener(MultTouchEvent.SELECT,onTouch);
//				this["btn"+i].addEventListener(MouseEvent.CLICK,onTouch);
			}
		}
		
		private var currentFocus:TextInput;
		private function ipFocusHandle(event:Event):void{
			currentFocus = iptxt;
			
		}
		
		private function portFocusHandle(event:Event):void{
			currentFocus = porttxt;
		}
		private function onTouch(event:Event):void{
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