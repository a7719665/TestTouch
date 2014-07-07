package manager
{
	/**
	 * @author Administrator
	 */
	import avmplus.getQualifiedClassName;
	
	import com.FilePath;
	import com.components.NokDialog;
	import com.data.DialogData;
	
	import flash.display.MovieClip;
	
	import game.logic.ControlScreen;
	import game.logic.MainScreen;
	import game.ui.view.ControlScreenUI;
	
	import morn.core.handlers.Handler;
	
	public class ViewManager
	{
		/**用作窗口排序或者关闭其他窗口*/
		public var xml:XML;
		private var _view: NokDialog;   //Morn UI 的View
		private static var _me:ViewManager
		private var _data:DialogData;
		public static function get me():ViewManager
		{
			if(!_me)_me=new ViewManager();
			return _me;
		}
		
		public function ViewManager()
		{
			_view = null;
		}
		
		public function setView($data:DialogData):void
		{
			_data = $data;
			
			var testStr:String = getQualifiedClassName(_data.className);
			var arr:Array = testStr.split("::");
			_data.winName = arr[1];
			/**如果界面已打开，关闭它*/
			if(LayerManager.me.getTempDialogByName(_data.winName)){
				var dialog:NokDialog = LayerManager.me.getTempDialogByName(_data.winName) as NokDialog;
				if(dialog.scaleX!=1)
					return;
				dialog.close();
				return;
			}
//			checkClose(_data);
			
			var path:String ;
			switch(_data.winName){
				case "MainScreen": 
					path = FilePath.MAINSWF;
					break;
				case "ControlScreen": 
					path = FilePath.TEMPSWF;
					break;
				default:
					loadCom();
					return;
			}
			
			
		
			if(!App.loader.getResLoaded(path)){
				roll=new INIT_LOADING();
				LayerManager.me.stageTopLayer.addChild(roll);
				if (roll) {
					roll.x=(LayerManager.stageWidth - 40) / 2;
					roll.y=(LayerManager.stageHeight - 40) / 2;
				}
				App.loader.loadAssets([path],new Handler(loadCom));
			}else
				loadCom();
		}
		

		private var INIT_LOADING:Class=Global.INIT_LOADING;
		private var roll:MovieClip;
		
		/**如果打开的界面里面不是和所要打开界面共存的，就关闭它*/
		private function checkClose($data:DialogData):void{
			var mutual:String = xml.window.(@name==$data.winName).@mutual;
			var mutualArr:Array = mutual.split(",");
			if(mutual!=""){
				for(var key:String in LayerManager.me.dynamicDic){
					if(mutualArr.indexOf(key)<0){
						var dialog:NokDialog = LayerManager.me.getDialogByName(key) as NokDialog;
						dialog.close();
					}
						
				}
			}else{
				LayerManager.me.cleanDynamicSprite();
			}
		}
		
		public function closeByClassName($cls:Class):void{
			var testStr:String = getQualifiedClassName($cls);
			var classname:String = testStr.split("::")[1];
			if(LayerManager.me.getTempDialogByName(classname)){
				var dialog:NokDialog = LayerManager.me.getTempDialogByName(_data.winName) as NokDialog;
				if(dialog.scaleX!=1)
					return;
				dialog.close();
				return;
			}
		}
		
		private function loadCom():void{
			if(roll){
				LayerManager.me.stageTopLayer.removeChild(roll);
				roll.stop();
				roll = null;
			}
			//新建要创建的界面
			_view = createView(_data.className);
			_view.dialogData = _data;
			//添加界面到动态层
			LayerManager.me.addToLayer(_view,LayerManager.STAGE_DYNAMIC_LAYER);
 		}
		
		public function createView(cls : Class) : NokDialog
		{
			return new cls();
		}
	}
	
}