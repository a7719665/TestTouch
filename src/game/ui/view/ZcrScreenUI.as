/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	import game.logic.GridPanel;
	public class ZcrScreenUI extends NokDialog {
		public var leftTxt:TextArea;
		public var rightTxt:TextArea;
		public var grid:GridPanel;
		public var timeTxt1:Label;
		public var drawSp:Box;
		public var timeTxt2:Label;
		protected var uiXML:XML =
			<NokDialog>
			  <Box x="-6" y="128" width="180" height="469">
			    <Image url="png.main.panel" x="0" y="0" sizeGrid="40,50,40,40" width="181" height="466"/>
			    <TextArea x="14" y="43" width="152" height="408" var="leftTxt" isHtml="true" wordWrap="true" multiline="true" editable="false" bold="true" leading="5"/>
			  </Box>
			  <Box x="654" y="141">
			    <Image url="png.main.panel" x="0" y="0" sizeGrid="40,50,40,40" width="186" height="451"/>
			    <TextArea x="16" y="43" width="158" height="395" var="rightTxt" isHtml="true" multiline="true" wordWrap="true" editable="false" bold="true" leading="5"/>
			  </Box>
			  <GridPanel x="179" y="136" var="grid" runtime="game.logic.GridPanel"/>
			  <Label text="选手：李雷" x="11" y="18" isHtml="true" width="112" height="25" color="0xff00" size="18" skin="png.comp.item" align="center"/>
			  <Label text="05:00" x="13" y="47" isHtml="true" width="111" height="25" var="timeTxt1" color="0xff0000" size="18" skin="png.comp.item" align="center"/>
			  <Label text="50" x="127" y="30" isHtml="true" width="63" height="31" color="0xffffff" size="18" skin="png.main.head.level" align="center"/>
			  <Box x="199" y="0" var="drawSp">
			    <Image url="png.main.bluebg2" sizeGrid="10,10,10,10" width="450" height="100" x="0" y="0"/>
			  </Box>
			  <Label text="选手：韩梅梅" x="734" y="21" isHtml="true" width="120" height="25" color="0xff00" size="18" skin="png.comp.item" align="center"/>
			  <Label text="04:12" x="733" y="51" isHtml="true" width="118" height="25" var="timeTxt2" color="0xff0000" size="18" skin="png.comp.item" align="center"/>
			  <Label text="50" x="660" y="32" isHtml="true" width="63" height="31" color="0xffffff" size="18" skin="png.main.head.level" align="center"/>
			  <Button label="对" skin="png.comp.btn_yellow" x="325" y="107"/>
			  <Button label="错" skin="png.comp.btn_yellow" x="442" y="107"/>
			</NokDialog>;
		public function ZcrScreenUI(){}
		override protected function createChildren():void {
			viewClassMap["game.logic.GridPanel"] = GridPanel;
			createView(uiXML);
		}
	}
}