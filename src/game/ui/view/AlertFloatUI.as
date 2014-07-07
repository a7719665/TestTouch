/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class AlertFloatUI extends NokDialog {
		public var txt:Label;
		public var autoTxt:Label;
		protected var uiXML:XML =
			<NokDialog>
			  <Box x="0" y="0">
			    <Image url="png.main.temp.bluebg" sizeGrid="54,27,54,15" width="243" height="97" x="0" y="0"/>
			    <Label text="错误" x="87" y="5" width="65" height="21" align="center" size="15" stroke="0xffffff"/>
			    <Label text="默认文字" x="3" y="36" width="237" height="22" align="center" isHtml="true" multiline="true" color="0xffffff" stroke="0x0" size="14" var="txt"/>
			    <Label text="3s后自动消失" x="26" y="58" width="198" height="21" align="center" var="autoTxt"/>
			  </Box>
			</NokDialog>;
		public function AlertFloatUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}