package utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.superkaka.kakalib.optimization.BitmapMovieRole;
	import org.superkaka.kakalib.optimization.PixelInteractiveBitmapMovie;

	public class EnterframeManager
	{
		private var displayVec:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		
		private var dic:Dictionary = new Dictionary();
		private static var instance:EnterframeManager;
		public function EnterframeManager()
		{
			if(!instance){
				
			}else{
				trace("禁止私自实例化")
			}
		}
		
		public function setUp($stage:Stage):void{
			$stage.addEventListener(Event.ENTER_FRAME,onRender);
		}
		
		public static function getInstance():EnterframeManager{
			if(!instance){
				instance = new EnterframeManager();
			}
			return instance;
		}
		
		private function onRender(evt:Event):void{
			for(var key:* in dic){
				var call:Function = dic[key] as Function;
				call.apply(null,[key ]);
 			}
		}
		
		public function pushItToRender($dis:*,$call:Function):void{
			dic[$dis] = $call;
		}
		
		public function deleteOne($dis:*):void{
			delete dic[$dis];
		}
		
		public function get len():int{
			var i:int=0;
			for(var key:* in dic){
				i++;
			}
			return i;
		}
		
	}
}