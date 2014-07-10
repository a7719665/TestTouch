/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class DScoreTypeViewUI extends NokDialog {
		public var taiBtn:Button;
		public var weiBtn:Button;
		public var canBtn:Button;
		protected var uiXML:XML =
			<NokDialog>
			  <Image url="png.main.bluebg2" x="0" y="0" sizeGrid="10,10,10,10" width="347" height="244"/>
			  <Button label="台球制" skin="png.comp.button" x="22" y="73" var="taiBtn"/>
			  <Button label="围棋制" skin="png.comp.button" x="138" y="73" var="weiBtn"/>
			  <Button label="残局" skin="png.comp.button" x="259" y="76" var="canBtn"/>
			</NokDialog>;
		public function DScoreTypeViewUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}