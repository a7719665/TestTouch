package
{
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	[SWF(width=320, height=460, frameRate=24, backgroundColor=0xEB7F00)]
	public class MultitouchExample extends Sprite
	{
		private var dots:Object;
		private var labels:Object;
		private var labelFormat:TextFormat;
		private var dotCount:uint;
		private var dotsLeft:TextField;
		private static const LABEL_SPACING:uint = 15;
		
		public function MultitouchExample()
		{
			super();

			this.labelFormat = new TextFormat();
			labelFormat.color = 0xACF0F2;
			labelFormat.font = "Helvetica";
			labelFormat.size = 11;
			
			this.dotCount = 0;

			this.dotsLeft = new TextField();
			this.dotsLeft.width = 300;
			this.dotsLeft.defaultTextFormat = this.labelFormat;
			this.dotsLeft.x = 3;
			this.dotsLeft.y = 0;
			this.stage.addChild(this.dotsLeft);
			this.updateDotsLeft();

			this.dots = new Object();
			this.labels = new Object();

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			this.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			this.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}

		private function onTouchBegin(e:TouchEvent):void
		{
			if (this.dotCount == Multitouch.maxTouchPoints) return;
			var dot:Sprite = this.getCircle();
			dot.x = e.stageX;
			dot.y = e.stageY;
			this.stage.addChild(dot);
			dot.startTouchDrag(e.touchPointID, true);
			this.dots[e.touchPointID] = dot;
			
			++this.dotCount;

			var label:TextField = this.getLabel(e.stageX + ", " + e.stageY);
			label.x = 3;
			label.y = this.dotCount * LABEL_SPACING;
			this.stage.addChild(label);
			this.labels[e.touchPointID] = label;

			this.updateDotsLeft();
		}
		
		private function onTouchMove(e:TouchEvent):void
		{
			var label:TextField = this.labels[e.touchPointID];
			label.text = (e.stageX + ", " + e.stageY);
		}
		
		private function onTouchEnd(e:TouchEvent):void
		{
			var dot:Sprite = this.dots[e.touchPointID];
			var label:TextField = this.labels[e.touchPointID];
			
			this.stage.removeChild(dot);
			this.stage.removeChild(label);
			
			delete this.dots[e.touchPointID];
			delete this.labels[e.touchPointID];
			
			--this.dotCount;

			this.updateDotsLeft();
		}
		
		private function getCircle(circumference:uint = 40):Sprite
		{
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(0x1695A3);
			circle.graphics.drawCircle(0, 0, circumference);
			return circle;
		}

		private function getLabel(initialText:String):TextField
		{
			var label:TextField = new TextField();
			label.defaultTextFormat = this.labelFormat;
			label.selectable = false;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.text = initialText;
			return label;
		}
		
		private function updateDotsLeft():void
		{
			this.dotsLeft.text = "Touches Remaining: " + (Multitouch.maxTouchPoints - this.dotCount);
		}
	}
}
