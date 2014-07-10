/**Created by the Morn,do not modify.*/
package game.ui.view {
	import morn.core.components.*;
	import  com.components.*;
	public class RectItemUI extends View {
		public var btnclip:FrameClip;
		public var label1:TextArea;
		protected var uiXML:XML =
			<View>
			  <Box name="render" x="0" y="0" mouseChildren="false" mouseEnabled="true">
			    <FrameClip skin="frameclip_btn" width="45" height="45" frame="2" var="btnclip" mouseChildren="false" mouseEnabled="false"/>
			    <TextArea x="2" y="1" width="41" height="41" editable="false" isHtml="true" color="0x3300ff" bold="true" var="label1" mouseChildren="false" mouseEnabled="false"/>
			  </Box>
			</View>;
		public function RectItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}