/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class AlertOkUI extends NokDialog {
		public var confirmBtn:Button;
		public var txt:Label;
		protected var uiXML:XML =
			<NokDialog>
			  <Box x="0" y="0">
			    <Image url="png.main.temp.bluebg" sizeGrid="54,27,54,15" width="273" height="168" x="0" y="0"/>
			    <Label text="错误" x="99" y="4" width="65" height="21" align="center" size="15" stroke="0xffffff"/>
			    <Button skin="png.main.temp.btn_close2" x="244" y="5" name="close"/>
			    <Button label="确定" skin="png.main.temp.btn_yellow" x="97" y="125" var="confirmBtn"/>
			    <Box x="9" y="44">
			      <Image url="png.main.bluebg2" sizeGrid="10,10,10,10" width="255" height="78" x="0" y="0"/>
			      <Label text="你不应该这样做懂么！" x="9" y="27" width="237" height="22" align="center" isHtml="true" multiline="true" color="0xffffff" stroke="0x0" size="14" var="txt" wordWrap="true"/>
			    </Box>
			  </Box>
			</NokDialog>;
		public function AlertOkUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}