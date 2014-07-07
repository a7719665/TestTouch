package com.eelpo.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class NokFont
	{
		private var _fontWidth:Number;
		private var _fontHeight:Number;
		private var _x:Number;
		private var _y:Number;
		private var _parent:DisplayObjectContainer;
		public static var CENTER:int=2;
		public static var LEFT:int=1;
		public static var RIGHT:int=3;
		private var _maxWidth:int;
		private var _aligh:int;
		private var numBitmap:BitmapData;
		public function NokFont($parent:DisplayObjectContainer,$x:int,$y:int,$fontName:String='png.main.head.zhanliNum',maxWidth:int=0,aligh:int=1)
		{
			super();
			_parent=$parent;
			
 			_x=$x;
			_y=$y;
			numBitmap = App.asset.getBitmapData($fontName);
			
			_fontWidth=numBitmap.width/10;
			_fontHeight=numBitmap.height;
			
			_maxWidth=maxWidth;
			_aligh=aligh;
		}
		
		private var firstNum:Bitmap;
		private var _length:int;
		private var numArr:Array=[];
		private var _text:int;
		private var bitmapArr:Array=[];

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get length():int
		{
			return _length;
		}

		public function set length(value:int):void
		{
			_length = value;
		}

		public function setText($num:int):void{
			_text=$num;
			clearBitmap();
			numArr.length=0;
			var len:int=1;
			var a:int=$num;
			while(a>=10){
				var b:int=a/10;
				var c:int=a%10;
				numArr.push(c);
				a=b;
			}
			numArr.push(a);
			numArr.reverse();
			for(var i:int=0;i<numArr.length;i++){
				var bitmap:Bitmap = new Bitmap(new BitmapData(_fontWidth,_fontHeight));
				bitmap.bitmapData.copyPixels(numBitmap,new Rectangle(numArr[i]*_fontWidth,0,_fontWidth,_fontHeight),new Point(0, 0));
				_parent.addChild(bitmap);
				bitmap.x=_x+(i*_fontWidth);
				bitmap.y=_y;
				bitmapArr.push(bitmap);
					
			}
			var allBitmap:Bitmap
			_length=_fontWidth*numArr.length;
			
			switch(_aligh){
				case LEFT:
//					for(var i:int=0;i<bitmapArr.length;i++){
//						bitmapArr.x
//					}
//					break;
				case CENTER:
					for(var iii:int=0;iii<bitmapArr.length;iii++){
						bitmapArr[iii].x+=(_maxWidth-_length)/2;
					}
					break;
				case RIGHT:
					for(var ii:int=0;ii<bitmapArr.length;ii++){
						bitmapArr[i].x+=(_maxWidth-_length);
					}
					break;
			}
		}
		
		private function clearBitmap():void{
			for(var i:int=0;i<bitmapArr.length;i++){
				var bitmap:Bitmap = bitmapArr[i];
				if(_parent.contains(bitmap)){
					_parent.removeChild(bitmap);
					bitmap.bitmapData.dispose();
				}
			}
			_length=0;
		}
		
		public function getText():int
		{
			return _text;
		}
	}
}