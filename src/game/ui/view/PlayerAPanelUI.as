/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class PlayerAPanelUI extends View {
		public var scoreTxt:Label;
		public var allTimeTxt:Label;
		public var oneTimerTxt:Label;
		public var allbtn:Button;
		public var onebtn:Button;
		protected var uiXML:XML =
			<View>
			  <Image url="png.main.panelBg" x="00" y="03" sizeGrid="15,15,15,15" width="146" height="143"/>
			  <Label text="分数：" x="14" y="23" isHtml="true" width="58" height="25" color="0xff0000" size="18" bold="true"/>
			  <Label text="15" x="68" y="23" isHtml="true" width="58" height="25" var="scoreTxt" color="0xff0000" size="18" bold="true"/>
			  <Label text="总时间：" x="14" y="59" isHtml="true" width="70" height="25" color="0xff0000" size="18" bold="true"/>
			  <Label text="300s" x="88" y="59" isHtml="true" width="58" height="25" var="allTimeTxt" color="0xff0000" size="18" bold="true"/>
			  <Label text="答题时间：" x="14" y="100" isHtml="true" width="91" height="25" color="0xff0000" size="18" bold="true"/>
			  <Label text="30s" x="103" y="100" isHtml="true" width="58" height="25" var="oneTimerTxt" color="0xff0000" size="18" bold="true"/>
			  <Button skin="png.main.head.btn_add" x="30" y="130" width="27" height="16" var="allbtn"/>
			  <Button skin="png.main.head.btn_add" x="79" y="130" width="27" height="16" var="onebtn"/>
			</View>;
		public function PlayerAPanelUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}