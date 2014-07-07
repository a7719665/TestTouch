package com.touch.simulator
{
	import flash.display.Sprite;
	
	public class TouchControlPoint
	{
		public var x;
		
		public var y;
		
		public var touchID:int;
		
		public var isExist:Boolean;
		
		public var isMoved:Boolean;
		
		public function TouchControlPoint(id:int,x:int,y:int)
		{
			super();
			
			isExist=true;
			isMoved=true;
			touchID=id;
			
			this.x=x;
			this.y=y;
		}
		
		public function updata(x:int,y:int):void{
			isMoved=true;
			this.x=x;
			this.y=y;
		}
		
		public function remove(x:int,y:int):void{
			isExist=false;
			isMoved=true;
			this.x=x;
			this.y=y;
		}
	}
}