/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	import game.logic.GridPanel;
	public class MainScreenUI extends NokDialog {
		public var tipTxt:Label;
		public var grid:GridPanel;
		public var timeTxt1:Label;
		public var timeTxt2:Label;
		protected var uiXML:XML =
			<NokDialog>
			  <Label text="题目显示区" x="429" y="5" isHtml="true" width="218" height="25" var="tipTxt" color="0xff0000" size="18"/>
			  <GridPanel x="327" y="37" var="grid" runtime="game.logic.GridPanel"/>
			  <Image url="png.main.panel" sizeGrid="40,50,40,40" width="319" height="463" x="7" y="37"/>
			  <Label text="05:00" x="102" y="257" isHtml="true" width="111" height="25" var="timeTxt1" color="0xff0000" size="18" skin="png.comp.item" align="center"/>
			  <Label text="选手：李雷" x="102" y="126" isHtml="true" width="112" height="25" color="0xff00" size="18" skin="png.comp.item" align="center"/>
			  <Label text="50" x="121" y="193" isHtml="true" width="63" height="31" color="0xffffff" size="18" skin="png.main.head.level" align="center"/>
			  <Image url="png.main.bluebg2" sizeGrid="10,10,10,10" width="273" height="100" x="32" y="367"/>
			  <Image url="png.main.panel" sizeGrid="40,50,40,40" width="319" height="463" x="804" y="43"/>
			  <Label text="05:00" x="899" y="263" isHtml="true" width="111" height="25" var="timeTxt2" color="0xff0000" size="18" skin="png.comp.item" align="center"/>
			  <Label text="选手：韩梅梅" x="899" y="132" isHtml="true" width="112" height="25" color="0xff00" size="18" skin="png.comp.item" align="center"/>
			  <Label text="50" x="918" y="199" isHtml="true" width="63" height="31" color="0xffffff" size="18" skin="png.main.head.level" align="center"/>
			  <Image url="png.main.bluebg2" sizeGrid="10,10,10,10" width="273" height="100" x="831" y="369"/>
			</NokDialog>;
		public function MainScreenUI(){}
		override protected function createChildren():void {
			viewClassMap["game.logic.GridPanel"] = GridPanel;
			createView(uiXML);
		}
	}
}