package utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * 资源加载
	 */
	public class LoaderInfoUtils extends BaseUtils
	{
		/**
		 * Loader 
		 */		
		private var _loader:Loader;
		
		/**
		 * 进度回调函数 
		 */		
		private var _onProgressCallback:Function;
		
		/**
		 * 加载完成回调函数 
		 */		
		private var _onCompleteCallback:Function;
		
		/**
		 * 加载路径 
		 */		
		private var _path:String;
		
		
		/**
		 * 加载 
		 * @param path
		 * @param progressCallback
		 * @param completeCallback
		 * @param applicationDomain
		 * 
		 */		
		public function load(path:String, progressCallback:Function = null, completeCallback:Function = null, applicationDomain:ApplicationDomain = null):void
		{
			this._path = path;
			
			this._onProgressCallback = progressCallback;
			this._onCompleteCallback = completeCallback;
			
			if($.isNull(applicationDomain))
			{
				applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			}
			
			if($.isNull(this._loader)){
				this._loader = new Loader();
			}
			this.unRegisterEventListener();
			this.registerEventListener();
			
			var urlRequest:URLRequest = new URLRequest(this._path);
			this._loader.load(urlRequest, new LoaderContext(true, applicationDomain));
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		override public function destory():void
		{
			if($.isNull(this._loader))
			{
				this.unRegisterEventListener();
				this._loader = null;
			}
			
			this._onProgressCallback = null;
			this._onCompleteCallback = null;
		}
		
		private function callback(content:*):void
		{
			if(this._onCompleteCallback is Function) this._onCompleteCallback(this._path, content);
		}
		
		/**
		 * 加载完成事件 
		 * @param eventHandler
		 * 
		 */		
		private function onCompleteHandler(eventHandler:Event):void
		{
			this.callback(eventHandler.target);
		}
		
		/**
		 * 加载进度事件 
		 * @param eventHandler
		 * 
		 */		
		private function onProgressHandler(eventHandler:ProgressEvent):void
		{
			if(this._onProgressCallback is Function) this._onProgressCallback(this._path, eventHandler.bytesLoaded, eventHandler.bytesTotal);
		}
		
		/**
		 * HttpStatus  
		 * @param eventHandler
		 * 
		 */		
		private function onHttpStatusHandler(eventHandler:HTTPStatusEvent):void
		{
			//this.callback(null);
		}
		
		/**
		 * IOError 
		 * @param eventHandler
		 * 
		 */		
		private function onIOErrorHandler(eventHandler:IOErrorEvent):void
		{
			//this.callback(null);
		}
		
		/**
		 * SecurityError 
		 * @param eventHandler
		 * 
		 */		
		private function onSecurityErrorHandler(eventHandler:SecurityErrorEvent):void
		{
			//this.callback(null);
		}
		
		/**
		 * 添加加载事件 
		 * 
		 */		
		private function registerEventListener() : void
		{
			var loaderInfo:LoaderInfo = this._loader.contentLoaderInfo;
			
			if (!loaderInfo.hasEventListener(Event.COMPLETE))
			{
				loaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			}
			if (!loaderInfo.hasEventListener(ProgressEvent.PROGRESS))
			{
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			}
			if (!loaderInfo.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			{
				loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			}
			if (!loaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			}
			if (!loaderInfo.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			}
		}
		
		/**
		 * 卸载加载事件 
		 * 
		 */		
		private function unRegisterEventListener() : void
		{
			var loaderInfo:LoaderInfo  = this._loader.contentLoaderInfo;
			
			if(loaderInfo.hasEventListener(Event.COMPLETE))
			{
				loaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			}
			if(loaderInfo.hasEventListener(ProgressEvent.PROGRESS))
			{
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			}
			if(loaderInfo.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			{
				loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			}
			if(loaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			}
			if(loaderInfo.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			}
		}
	}
}