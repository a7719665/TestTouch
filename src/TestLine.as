package
{
	import com.FilePath;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import morn.core.handlers.Handler;
	import morn.core.managers.ResLoader;

	
	public class TestLine extends Sprite
	{
		public function TestLine()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var trapezoid:Shape = new Shape();    
			
//			trapezoid.graphics.lineStyle(10,1);
//			trapezoid.graphics.moveTo(100,100);
//			trapezoid.graphics.lineTo(200,100);
//			trapezoid.graphics.lineTo(200,200);
//			trapezoid.graphics.lineTo(100,200);
//			trapezoid.graphics.lineTo(100,100);
			
			
			
			trapezoid.graphics.beginFill(0xffcccc,1);
			trapezoid.graphics.drawRect(20,20,150,150);
			trapezoid.graphics.endFill();
			
			this.addChild(trapezoid);
			
			var rect:Rectangle = trapezoid.getBounds(this);
			
//			var m:Matrix = trapezoid.transform.matrix;
//			m.tx -= rect.x;
//			m.ty -= rect.y;
			
			var bmd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
//			var bmd:BitmapData = new BitmapData(110,100,true,0);
			bmd.draw(trapezoid);
			var bmp:Bitmap = new Bitmap(bmd);
			this.addChild(bmp);
			bmp.x = 250;
			
			App.init(this);
			
		}
	}
}

