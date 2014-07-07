package utils
{
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;

	/**
	 * 资源加载器
	 */
	public class LoaderUtils extends BaseUtils
	{
		/**
		 * 加载器 
		 */		
		private static var _loaderInfoUtils:LoaderInfoUtils;
		
		/**
		 * 加载列表 
		 */		
		private static var _loaderList:Array = [];
		
		/**
		 * 回调函数 
		 */		
		private static var _callbackList:Array = [];
		
		/**
		 * 当前加载状态 
		 */		
		private static var _loaderStatus:Boolean = false;
		
		public function LoaderUtils()
		{
			throw new Error("LoaderUtils can not be Instantiated!");
		}
		
		/**
		 * 顺序加载 
		 * @param pathList 加载路径
		 * @param callback 加载结束回调，参数：路径，LoaderInfo
		 * @param progressCallback 加载进度回调，参数：路径，当前加载，总大小
		 * @param completeCallback 加载完成回调
		 * @param applicationDomain 加载域
		 * 
		 */			
		public static function load(pathList:Array, callback:Function = null, progressCallback:Function = null, completeCallback:Function = null, applicationDomain:ApplicationDomain = null):void
		{
			_loaderList = _loaderList.concat(pathList);
			
			if($.isNull(_callbackList)) _callbackList = [];
			
			_callbackList.push({"value" : pathList, "callback" : callback, "progressCallback" : progressCallback, "completeCallback" : completeCallback, "applicationDomain" : applicationDomain});
			
			if(!_loaderStatus){
				beginLoad();
			}
		}
		
		/**
		 * 加载 
		 * 
		 */		
		private static function beginLoad():void
		{
			if (_loaderList.length > 0) {
				
				_loaderStatus = true;
				
				var path:String = _loaderList.pop();
				
				var loaderIndex:int = getCallbackIndexByValue(path);
				
				if(loaderIndex == -1) throw new Error("Callback Can Not Null !");
				
				if($.isNull(_loaderInfoUtils)) _loaderInfoUtils = new LoaderInfoUtils();
				
				_loaderInfoUtils.load(path, _callbackList[loaderIndex]["progressCallback"], function(loaderPath:String, loaderInfo:LoaderInfo):void{
					
					validLoader(loaderPath, loaderInfo);
					beginLoad();
					
				}, _callbackList[loaderIndex]["applicationDomain"]);
				
			}else{
				
				if(!$.isNull(_loaderInfoUtils)) _loaderInfoUtils.destory();
				_loaderStatus = false;
			}
		}
		
		/**
		 * 加载完成处理 
		 * @param path
		 * @param loaderInfo
		 * 
		 */		
		private static  function validLoader(path:String, loaderInfo:LoaderInfo):void
		{
			var loaderIndex:int = getCallbackIndexByValue(path);
			if(loaderIndex != -1){
				
				_callbackList[loaderIndex]["callback"](path, loaderInfo);
				
				var pathList:Array = _callbackList[loaderIndex]["value"] as Array;
				if(!$.isNull(pathList) && pathList.length > 0){
					
					var keyIndex:int = getCallbackKeyIndex(pathList, path);
					if(keyIndex != -1){
						
						pathList.splice(keyIndex, 1);
						
						_callbackList[loaderIndex]["value"] = pathList;
						
						if(pathList.length == 0){
							_callbackList[loaderIndex]["completeCallback"]();
							_callbackList.splice(loaderIndex, 1);
						}
						
					}else{
						throw new Error("Callback Can Not Null !");
					}
				}
			}else{
				throw new Error("Callback Can Not Null !");
			}
		}
		
		/**
		 * 获取回调数据 
		 * @param keyValue
		 * @return 
		 * 
		 */		
		private static function getCallbackIndexByValue(keyValue:String):int
		{
			if($.isNull(_callbackList) || _callbackList.length == 0) return -1;
			
			var index:int = 0;
			for each(var callbackItem:Object in _callbackList){
				for each(var path:String in callbackItem["value"] as Array){
					if(keyValue == path) return index;
				}
				index ++;
			}
			return -1;
		}
		
		/**
		 * 获取回调函数 
		 * @param pathList
		 * @param keyValue
		 * @return 
		 * 
		 */		
		private static function getCallbackKeyIndex(pathList:Array, keyValue:String):int
		{
			if($.isNull(pathList) || pathList.length == 0) return -1;
			
			var index:int = 0;
			for each(var path:String in pathList){
				if(keyValue == path) return index;
				index ++;
			}
			return -1;
		}
	}
}