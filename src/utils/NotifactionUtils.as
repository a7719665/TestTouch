package utils
{
	import flash.utils.Dictionary;
	
	/**
	 * 模拟事件机制
	 */
	public class NotifactionUtils extends BaseUtils
	{
		/**
		 * 回调函数列表 
		 */		
		private var _dictionary:Dictionary;
		
		/**
		 * 判断是否存在函数类别 
		 * @param notificationType
		 * @return 
		 * 
		 */		
		public function hasNotification(notificationType:String):Boolean
		{
			if($.isNull(this._dictionary)) return false;
			
			for(var key:String in this._dictionary){
				if(key == notificationType){
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 注册函数 
		 * @param notificationType
		 * @param callback
		 * 
		 */		
		public function registerNotification(notificationType:String, callback:Function):void
		{
			if($.isNull(this._dictionary)) this._dictionary = new Dictionary();
			
			if(_dictionary[notificationType] != null){
				var index:int = this.getIndex(callback, _dictionary[notificationType]);
				if(index == -1){
					_dictionary[notificationType].push(callback);
				}
			}else{
				_dictionary[notificationType] = [callback];
			}
		}
		
		/**
		 * 取消注册函数 
		 * @param notificationType
		 * @param callback
		 * 
		 */		
		public function unRegisterNotification(notificationType:String, callback:Function):void
		{
			if($.isNull(this._dictionary)) return;
			
			if(_dictionary[notificationType] != null){
				
				var index:int = this.getIndex(callback, _dictionary[notificationType]);
				
				if(index != -1){
					_dictionary[notificationType].splice(index, 1);
				}
			}
		}
		
		/**
		 * 发送消息 
		 * @param notificationType
		 * @param data
		 * 
		 */		
		public function sendNotification(notificationType:String, ...data):void
		{
			if(_dictionary[notificationType] != null){
				_dictionary[notificationType].forEach(function(callback:Function, index:int, list:Array):void{
					callback.apply(null, data);
				});
			}
		}
		
		override public function destory():void
		{
			this._dictionary = null;
		}
		
		/**
		 * 判断是否存在回调函数 
		 * @param callback
		 * @param list
		 * @return 
		 * 
		 */		
		private function getIndex(callback:Function, list:Array):int
		{
			var index:int = 0;
			for each(var func:Function in list){
				if(func == callback) return index;
				index ++;
			}
			return -1;
		}
	}
}