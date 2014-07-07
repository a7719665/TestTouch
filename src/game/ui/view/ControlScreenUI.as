/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class ControlScreenUI extends NokDialog {
		protected var uiXML:XML =
			<NokDialog>
			  <Box x="0" y="0">
			    <Button label="选手A分数" skin="png.main.temp.btn_yellow" x="4" y="3" width="87"/>
			    <Button label="选手B分数" skin="png.main.temp.btn_yellow" x="208" width="87"/>
			    <Button label="选手A所剩时间" skin="png.main.temp.btn_yellow" x="3" y="48" width="87" height="27"/>
			    <Button label="选手B所剩时间" skin="png.main.temp.btn_yellow" x="210" y="48" width="87" height="27"/>
			    <Button label="选手A答题" skin="png.main.temp.btn_yellow" x="5" y="97" width="87" height="27"/>
			    <Button label="选手B答题" skin="png.main.temp.btn_yellow" x="212" y="101" width="87" height="27"/>
			    <Label text="选手名字(李雷)" x="106" y="143"/>
			    <Button label="游戏开始" skin="png.main.temp.btn_yellow" y="185" width="87" height="27"/>
			    <Button label="游戏结束" skin="png.main.temp.btn_yellow" x="204" y="181" width="87" height="27"/>
			    <Button label="暂停" skin="png.main.minimap.btn_function" x="130" y="171" sizeGrid="10,10,10,10" width="40" height="40"/>
			  </Box>
			</NokDialog>;
		public function ControlScreenUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}