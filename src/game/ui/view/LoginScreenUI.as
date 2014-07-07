/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class LoginScreenUI extends NokDialog {
		protected var uiXML:XML =
			<NokDialog>
			  <Image url="png.main.bluebg2" x="1" y="1" sizeGrid="10,10,10,10" width="347" height="244"/>
			  <Label text="IP:" x="66" y="37" color="0xffffff" stroke="0x0"/>
			  <TextInput text="192.168.1.1" skin="png.main.textinput_temp" x="94" y="37" color="0xffffff" stroke="0x0"/>
			  <Label text="port:" x="66" y="59" color="0xffffff" stroke="0x0"/>
			  <TextInput text="8000" skin="png.main.textinput_temp" x="95" y="59" color="0xffffff" stroke="0x0" editable="true"/>
			  <Button label="登录" skin="png.main.task.btn_accepted" x="107" y="106" labelColors="0xffffff"/>
			</NokDialog>;
		public function LoginScreenUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}