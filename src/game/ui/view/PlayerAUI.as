/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class PlayerAUI extends NokDialog {
		protected var uiXML:XML =
			<NokDialog>
			  <Image url="png.main.bluebg2" x="0" y="0" width="1440" height="800" sizeGrid="10,10,10,10"/>
			  <Tab labels="主屏幕,选手A,选手B,控制屏" skin="png.main.temp.tab" x="505" y="81"/>
			</NokDialog>;
		public function PlayerAUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}