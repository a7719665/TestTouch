/**Created by the Morn,do not modify.*/
package game.ui.view.item {
	import morn.core.components.*;
	import  com.components.*;
	public class CardItemUI extends View {
		protected var uiXML:XML =
			<View>
			  <Box x="2" y="0">
			    <Image url="png.comp.bluebg" sizeGrid="70,30,30,50" width="196" height="292"/>
			    <Label text="A牌" x="81" y="6" color="0xffffff" stroke="0x66"/>
			    <Image url="png.comp.image" x="23" y="34"/>
			  </Box>
			</View>;
		public function CardItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}