package com.touch
{
	/**
	 * 触摸事件阶段
	 * @author IceFlame
	 */	
	public class MultTouchPhase
	{
		/** 没有触摸点 */
		public static const NULL_TOUCH:int = -1
		
		/** 没有可操作的触摸点 */
		public static const NO_AVAILABLE:int = 0;
		
		/** 触摸开始 */
		public static const TOUCH_BEGAN:int = 1;
		
		/** 触摸移动 */
		public static const TOUCH_MOVE:int = 2;
		
		/** 触摸结束 */
		public static const TOUCH_END:int = 3;
		
		/** 划入 */
		public static const TOUCH_OVER:int = 4;
		
		/** 划出 */
		public static const TOUCH_OUT:int = 5;
	}
}