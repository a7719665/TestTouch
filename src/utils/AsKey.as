package utils {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/*
	* Usage:
	* Key.initialize(stage);
	* if (Key.isDown(Keyboard.LEFT)) {
	* // Left key is being pressed
	* }
	*/         
	public class AsKey { //工具类
		private static var initialized:Boolean = false; 
		public static var keysDown:Object = new Object(); //可用数组,也可用对象
		
		public static function initialize(stage:Stage):void { //静态初始化方法
			if (!initialized) { //单例
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
				stage.addEventListener(Event.DEACTIVATE, clearKeys);
				initialized = true;
			}
		}
		
		public static function isDown(keyCode:uint):Boolean { //主方法
			if (!initialized) {
				throw new Error("Key class has yet been initialized.");
			}
			return Boolean(keyCode in keysDown);
		}
		
		private static function keyPressed(event:KeyboardEvent):void {
			keysDown[event.keyCode] = true;
		}
		
		private static function keyReleased(event:KeyboardEvent):void {
			if (event.keyCode in keysDown) {
				delete keysDown[event.keyCode];
			}
		}
		
		public static function clearKeys(event:Event):void {
			keysDown = new Object();
		}
	}
}