package utils
{
	/**
	 * 数学函数【禁止实例化】
	 */
	public class MathUtils
	{
		public function MathUtils()
		{
			throw new Error("MathUtils can not be Instantiated!");
		}
		
		/**
		 * 取随机值，取值范围 max > value >= min 
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public static function random(min:int = 1, max:int = 100):int
		{
			if(min == 0 && max == 1) return int(Math.round(Math.random()));
			
			return int(Math.random() * (max - min) + min);
		}
		
		/**
		 * 计算弧度 
		 * @param angle
		 * @return 
		 * 
		 */		
		public static function radian(angle:Number):Number
		{
			return (Math.PI * angle) / 180; 
		}
		
		/**
		 * 计算角度 
		 * @param radian
		 * @return 
		 * 
		 */		
		public static function angle(radian:Number):Number
		{
			return (radian * 180) / Math.PI;
		}
		
		/**
		 * 计算点与点之间的距离
		 */
		public static function distance(cx:int, cy:int, tx:int, ty:int):Number
		{
			var dx:int = Math.abs(cx - tx);
			var dy:int = Math.abs(cy - ty);
			
			var fMin:Number;
			var fMax:Number;
			
			if (dx < dy) {
				fMin = dx;
				fMax = dy;
			}
			else {
				fMax = dx;
				fMin = dy;
			}
			var m:Number = fMin / fMax;
			var q:Number = m * m * 0.37 + 0.05 * m;
			return fMax + fMax * q;
			
		}
	}
}