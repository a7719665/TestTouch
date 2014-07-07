/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	import game.logic.item.RectItem;
	public class GridPanelUI extends NokDialog {
		public var list:List;
		protected var uiXML:XML =
			<NokDialog>
			  <Box x="0" y="0">
			    <Image url="png.main.panelBg" sizeGrid="18,18,18,18" width="470" height="465"/>
			    <List x="11" y="8" repeatX="10" repeatY="10" var="list">
			      <RectItem x="0" y="0" name="render" runtime="game.logic.item.RectItem"/>
			    </List>
			  </Box>
			</NokDialog>;
		public function GridPanelUI(){}
		override protected function createChildren():void {
			viewClassMap["game.logic.item.RectItem"] = RectItem;
			createView(uiXML);
		}
	}
}