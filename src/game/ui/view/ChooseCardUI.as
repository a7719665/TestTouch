/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class ChooseCardUI extends NokDialog {
		protected var uiXML:XML =
			<NokDialog/>;
		public function ChooseCardUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}