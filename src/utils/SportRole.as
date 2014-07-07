package utils
{
	import flash.display.Sprite;
	
	public class SportRole extends Sprite
	{
		public var speed:int;
		/**跳跃横向初始X速度*/
		public var initJumpVelocityX:int=7;
		/**走掉下去的x速度*/
		public var initWalkVelocityX:int=11;
		/**初始Y速度*/
		public var initVelocityY:int=27;
		
		public var zeroVelocityY:int=0;
		private var _velocity:int;
		
		private var maxVelocity:int = 21;
		/**加速度*/
		public var gravity:Number = 3;  
		public var initX:int;
		public var initY:int;
		private var _inAir:Boolean;
		public function SportRole()
		{
			super();
		}

		public function get velocity():int
		{
			return _velocity;
		}

		public function set velocity(value:int):void
		{
			_velocity = value;
			if(_velocity > maxVelocity)
				_velocity = maxVelocity;
		}

		public function get inAir():Boolean
		{
			return _inAir;
		}

		public function set inAir(value:Boolean):void
		{
			_inAir = value;
		}
		
	}
}