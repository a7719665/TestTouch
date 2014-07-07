package manager
{
	import com.components.NokDialog;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import morn.core.components.View;

	public class LayerManager
	{
		/**最上层，放一些弹出提示框*/
		private var _stageTopLayer:Sprite;  
		/**中间层，放窗口*/
		private var _stageDynamicLayer:Sprite;
		/**底层，就放聊天栏，上部/下部导航栏，*/
		private var _stageBottomLayer:Sprite;
		
		public static const STAGE_TOP_LAYER:int = 0;
		public static const STAGE_DYNAMIC_LAYER:int = 1;
		public static const STAGE_BOTTOM_LAYER:int = 2;
		/**存放当前打开的窗口*/
		public static var windowsDic:Dictionary=new Dictionary();
		private var _dynamicDic:Dictionary = new Dictionary();
		/**舞台宽度*/
		public static var stageWidth:int;
		
		/**舞台高度*/
		public static var stageHeight:int;
		
		public function LayerManager()
		{
		}
		private static var _me:LayerManager;

		public function get dynamicDic():Dictionary
		{
			return _dynamicDic;
		}

		public function set dynamicDic(value:Dictionary):void
		{
			_dynamicDic = value;
		}

		public function get stageTopLayer():Sprite
		{
			return _stageTopLayer;
		}

		public function set stageTopLayer(value:Sprite):void
		{
			_stageTopLayer = value;
		}

		public function get stageDynamicLayer():Sprite
		{
			return _stageDynamicLayer;
		}

		public function set stageDynamicLayer(value:Sprite):void
		{
			_stageDynamicLayer = value;
		}

		public function get stageBottomLayer():Sprite
		{
			return _stageBottomLayer;
		}

		public function set stageBottomLayer(value:Sprite):void
		{
			_stageBottomLayer = value;
		}

		public static function get me():LayerManager
		{
			if(_me == null)
			{
				_me = new LayerManager();
			}
			return _me;
		}
		/**初始化界面上的ui层*/
		public function setup(stage:Sprite):void
		{
			_stageTopLayer = new Sprite();
			_stageDynamicLayer = new Sprite();
			_stageBottomLayer = new Sprite();
			
			
			stage.addChild(_stageBottomLayer);
			stage.addChild(_stageDynamicLayer);
			stage.addChild(_stageTopLayer);
			
//			var xml:XML = ViewManager.me.xml;
//			
//			var str:String = xml.window.(@name=="sort_window").@sort;
//			sortArr = str.split(",");
		}
		
		
		public function topSpriteAdd(view:View):void{
			_stageTopLayer.addChildAt(view,_stageTopLayer.numChildren);
			
			view.x = (LayerManager.stageWidth-view.width)/2;
			view.y = (LayerManager.stageHeight-view.height)/2;
			
		}

		public function bottomSpriteAdd(view:View):void{
			_stageBottomLayer.addChild(view);
//			if(view is IBottomBar){
//				GameGlobal.bottomView = view as IBottomBar;
//			}
//			if(view is IChatView){
//				GameGlobal.chatView = view as IChatView;
//			}
//			if(view is ITopView){
//				GameGlobal.topView = view as ITopView;
//			}
//			if(view is IHeadView){
//				GameGlobal.headView = view as IHeadView;
//			}
//			if(view is ITaskView){
//				GameGlobal.taskView = view as ITaskView;
//			}
//			if(view is IBottomSkillBar){
//				GameGlobal.bottomSkillView = view as IBottomSkillBar;
//			}
//			if(view is IMinimapView){
//				GameGlobal.minimapView=view as IMinimapView;
//			}
		}
		
		public function onSize():void{
			displayAllWindowByType();
		}
		
		public function getLayerByType(type:int):Sprite
		{
			switch(type)
			{
				case STAGE_TOP_LAYER:
					return _stageTopLayer;
					break;
				case STAGE_DYNAMIC_LAYER:
					return _stageDynamicLayer;
					break;
				case STAGE_BOTTOM_LAYER:
					return _stageBottomLayer;
					break;
			}
			return null;
		}
		/**关闭的时候直接删除字典，但有个tween动画，所以它的parent扔存在*/
		public function getDialogByName(type:String):DisplayObject{
			if(_dynamicDic[type]){
				return _dynamicDic[type];
			}
			return null;
		}
		
		/**关闭的时候直接删除字典，但有个tween动画，所以它的parent扔存在*/
		public function getTempDialogByName(childName:String):DisplayObject{
			if(_stageDynamicLayer.getChildByName(childName))
				return _stageDynamicLayer.getChildByName(childName);
			return null;
		}
		
		public function addToLayer(source:NokDialog,layertype:int,type:String=null):void
		{
			cleanDynamicSprite();
			var container:Sprite = getLayerByType(layertype);
			
			container.addChild(source);
			if(layertype == STAGE_DYNAMIC_LAYER){
				_dynamicDic[source.dialogData.winName] = source;
				source.mouseEnabled= false;
				if(source.dialogData.x!=0 || source.dialogData.y!=0 ){
					source.x = source.dialogData.x;
					source.y = source.dialogData.y;
				}else
					displayAllWindowByType();
			}
		}
		private var sortArr:Array;
		/**排列所有打开的窗口*/
		public function displayAllWindowByType():void{
			var dynamicArr:Array=[];
			var countLen:int;
			for(var key:String in _dynamicDic){
				var item:DisplayObject = _dynamicDic[key];
				countLen += item.width;
				
				dynamicArr.push(item);
			}
			
			if(dynamicArr.length>1){
				for(var i:int=0;i<dynamicArr.length-1;i++){
					var temp:NokDialog = dynamicArr[i] as NokDialog;
					var temp2:NokDialog = dynamicArr[i+1] as NokDialog;
					
					var swap:NokDialog;
					if(sortArr.indexOf(temp.dialogData.winName) > sortArr.indexOf(temp2.dialogData.winName)){
						swap = temp;
						dynamicArr[i] = dynamicArr[i+1];
						dynamicArr[i+1] = swap;
					}
				}
			}
			
			
			var lastitem:NokDialog;
			var point:Point = new Point();
			for(var key2:int=0;key2<dynamicArr.length;key2++){
				var item2:NokDialog = dynamicArr[key2];
				if(!lastitem){
					point.x = (LayerManager.stageWidth-countLen)/2;
				}else{
					point.x = (point.x +lastitem.width) ;
				}
				point.y = (LayerManager.stageHeight - item2.height) * 0.5;
 				lastitem = item2;
				if(item2.x != 0 && item2.y!=0)
					TweenMax.to(item2, 0.2, {x:point.x, y:point.y});
				else{
					item2.x = point.x;
					item2.y = point.y;
				}
			}
		}
		
		/**
		 * flash窗口尺寸改变
		 *
		 */
		public static function updateViewRect(w:int, h:int):void{
			stageWidth=w;
			stageHeight=h;
//			var headView:View=GameGlobal.headView as View;
//			if (headView)
//			{
//				headView.x=0;
//				headView.y=0;
//			}
		}
		
		/**移除某个窗口*/
		public function removeDynamicWindow(type:String):void{
			if(_dynamicDic[type]){
				delete _dynamicDic[type];
			}
		
		}
		/**关闭某个层所有的窗口*/
		public function cleanSprite(layertype:int):void
		{
			var vSpriteLayer:Sprite=getLayerByType(layertype);
			while(vSpriteLayer.numChildren>0)
			{
				var item:DisplayObject = vSpriteLayer.getChildAt(0);
				item.parent.removeChild(item);
 				item  = null;
			}
		}
		
		/**关闭窗口层所有的窗口*/
		/**
		 * 这里不知道为啥，dictionary总是 清空不了，说是for + delete就会有问题
		 * 
		 */
		public function cleanDynamicSprite():void
		{
			var arr:Array = [];
			for(var key:Object in _dynamicDic){
				var item:NokDialog = _dynamicDic[key];
				arr.push(item);
			}
			_dynamicDic = new Dictionary();
			for(var i:int=0;i<arr.length;i++){
				var item2:NokDialog = arr[i];
				item2.close();
				item2 = null;
				trace(key);
			}
		}
		
	}

}