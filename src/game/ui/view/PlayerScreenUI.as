/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	import game.logic.GridPanel;
	import game.ui.view.item.CardItemUI;
	public class PlayerScreenUI extends NokDialog {
		public var card:CardItemUI;
		public var playerMain:Box;
		public var grid:GridPanel;
		public var tipTxt:Label;
		public var drawSp:Box;
		public var conmitBtn:Button;
		public var timeTxt2:Label;
		protected var uiXML:XML =
			<NokDialog>
			  <CardItem x="283" y="10" var="card" runtime="game.ui.view.item.CardItemUI"/>
			  <Box var="playerMain">
			    <GridPanel x="1" y="27" var="grid" runtime="game.logic.GridPanel"/>
			    <Label x="0" y="0" isHtml="true" width="218" height="25" var="tipTxt" color="0xff0000" size="18" text="狄仁杰经常对远方说的话" bold="true"/>
			    <Box x="499" y="120" var="drawSp">
			      <Image url="png.main.bluebg2" sizeGrid="10,10,,10,10" width="263" height="183"/>
			    </Box>
			    <Button label="取消" skin="png.comp.btn_yellow" x="527" y="410"/>
			    <Button label="提交" skin="png.comp.btn_yellow" x="659" y="411" var="conmitBtn"/>
			    <Label text="05:00" x="507" y="35" isHtml="true" width="111" height="25" var="timeTxt2" color="0xff0000" size="18" skin="png.comp.item" align="center"/>
			    <Label text="50" x="634" y="36" isHtml="true" width="63" height="31" color="0xffffff" size="18" skin="png.main.head.level" align="center"/>
			  </Box>
			</NokDialog>;
		public function PlayerScreenUI(){}
		override protected function createChildren():void {
			viewClassMap["game.logic.GridPanel"] = GridPanel;
			viewClassMap["game.ui.view.item.CardItemUI"] = CardItemUI;
			createView(uiXML);
		}
	}
}