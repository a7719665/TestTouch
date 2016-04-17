/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class LoginScreenUI extends NokDialog {
		public var iptxt:TextInput;
		public var porttxt:TextInput;
		public var loginBtn:Button;
		public var btn1:Button;
		public var btn2:Button;
		public var btn3:Button;
		public var btn4:Button;
		public var btn5:Button;
		public var btn6:Button;
		public var btn7:Button;
		public var btn8:Button;
		public var btn9:Button;
		public var btn0:Button;
		public var btn11:Button;
		public var btn10:Button;
		protected var uiXML:XML =
			<NokDialog>
			  <Image url="png.main.bluebg2" x="1" y="1" sizeGrid="10,10,10,10" width="347" height="244"/>
			  <Label text="IP:" x="66" y="37" color="0xffffff" stroke="0x0"/>
			  <TextInput text="marsmus.xicp.net" skin="png.main.textinput_temp" x="94" y="37" color="0xffffff" stroke="0x0" var="iptxt"/>
			  <Label text="port:" x="66" y="59" color="0xffffff" stroke="0x0"/>
			  <TextInput text="7000" skin="png.main.textinput_temp" x="95" y="59" color="0xffffff" stroke="0x0" editable="true" var="porttxt" restrict="123456890"/>
			  <Button label="登录" skin="png.main.task.btn_accepted" x="107" y="106" labelColors="0xffffff" var="loginBtn"/>
			  <Image url="png.main.bluebg2" x="350" y="2" sizeGrid="10,10,10,10" width="242" height="243"/>
			  <Button label="1" skin="png.comp.button" x="378" y="19" width="50" height="45" var="btn1" name="btn1"/>
			  <Button label="2" skin="png.comp.button" x="445" y="21" width="50" height="45" var="btn2" name="btn2"/>
			  <Button label="3" skin="png.comp.button" x="514" y="21" width="50" height="45" var="btn3" name="btn3"/>
			  <Button label="4" skin="png.comp.button" x="378" y="75" width="50" height="45" var="btn4" name="btn4"/>
			  <Button label="5" skin="png.comp.button" x="445" y="76" width="50" height="45" var="btn5" name="btn5"/>
			  <Button label="6" skin="png.comp.button" x="515" y="77" width="50" height="45" var="btn6" name="btn6"/>
			  <Button label="7" skin="png.comp.button" x="379" y="132" width="50" height="45" var="btn7" name="btn7"/>
			  <Button label="8" skin="png.comp.button" x="447" y="134" width="50" height="45" var="btn8" name="btn8"/>
			  <Button label="9" skin="png.comp.button" x="515" y="133" width="50" height="45" var="btn9" name="btn9"/>
			  <Button label="0" skin="png.comp.button" x="379" y="191" width="50" height="45" var="btn0" name="btn0"/>
			  <Button label="Delete" skin="png.comp.button" x="516" y="191" width="50" height="45" var="btn11" name="btn11"/>
			  <Button label="." skin="png.comp.button" x="448" y="191" width="50" height="45" var="btn10" name="btn10"/>
			  <ComboBox labels="控制端,大屏幕,导师,主持人,选手A,选手B" skin="png.comp.combobox" x="244" y="37" selectedIndex="0"/>
			</NokDialog>;
		public function LoginScreenUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}