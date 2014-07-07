package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF(width=320, height=460, frameRate=24, backgroundColor=0x000000)]
	public class GestureExample extends Sprite
	{
		[Embed(source="african_elephant.jpg")]
		public var ElephantImage:Class;
		public var scaleDebug:TextField;
		public var rotateDebug:TextField;

		public function GestureExample()
		{
			// Debug
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.font = "Helvetica";
			tf.size = 11;
			this.scaleDebug = new TextField();
			this.scaleDebug.width = 310;
			this.scaleDebug.defaultTextFormat = tf;
			this.scaleDebug.x = 2;
			this.scaleDebug.y = 2;
			this.stage.addChild(this.scaleDebug);
			this.rotateDebug = new TextField();
			this.rotateDebug.width = 310;
			this.rotateDebug.defaultTextFormat = tf;
			this.rotateDebug.x = 2;
			this.rotateDebug.y = 15;
			this.stage.addChild(this.rotateDebug);

			var elephantBitmap:Bitmap = new ElephantImage();
			var elephant:Sprite = new Sprite();
			
			elephant.addChild(elephantBitmap);
			
			elephant.x = 160;
			elephant.y = 230;
			
			elephantBitmap.x = (300 - (elephantBitmap.bitmapData.width / 2)) * -1;
			elephantBitmap.y = (400 - (elephantBitmap.bitmapData.height / 2)) *-1;
			
			this.addChild(elephant);

			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			elephant.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			elephant.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onRotate);
		}
		
		private function onZoom(e:TransformGestureEvent):void
		{
			this.scaleDebug.text = (e.scaleX + ", " + e.scaleY);
			var elephant:Sprite = e.target as Sprite;
			elephant.scaleX *= e.scaleX;
			elephant.scaleY *= e.scaleY;
		}
		
		private function onRotate(e:TransformGestureEvent):void
		{
			var elephant:Sprite = e.target as Sprite;
			this.rotateDebug.text = String(e.rotation);
			elephant.rotation += e.rotation;
		}
	}
}