package
{
	import flash.geom.Point;

	public class Global
	{
		/**
		 * 舞台宽度 
		 */ 
		public static var W:uint=1440;
		/**
		 * 舞台高度
		 */  
		public static var H:uint=800;	
		
		/**
		 * 舞台最大宽度
		 */
		public static var MAX_W:int=1440;
		
		/**
		 * 舞台最大高度
		 */
		public static var MAX_H:int=800;
		
		/** 
		 * 地图单元格大小
		 */
		public static var TILE_SIZE:Point=new Point(250,131);   
		
		/**
		 * 砖块行数
		 */
		public static var TILE_ROW:uint=0;
		
		/**
		 * 砖块列数
		 */
		public static var TILE_COLUMN:uint=0;
		
		/**
		 * 地图全尺寸
		 */ 
		public static var MAPSIZE:Point = new Point(1250,655);
		
		/**
		 * 路点格子大小
		 */
		public static var GRID_SIZE:Point=new Point(20,20);
		
		/**
		 * 记录游戏运行的时间
		 */
		public static var TIMER:uint;
		
		/**
		 * 初始化图标
		 */
		[Embed(source="/assets/roll.swf", symbol='Roll')]
		public static var INIT_LOADING:Class;
		
		/**
		 * 资源路径
		 */
		public static var RESOURCE_PATH:String;
		
		/**
		 * 跳跃速度 
		 */
		public static var JUMP_SPEED:Number=-24;
		/**
		 * 重力加速
		 */
		public static var GRAVITY:Number=4;
		
		/**
		 * 移动速度
		 */
		public static var MOVE_SPEED:Number=8;
		
		
		public static var answer:Array;
		
		public static var question:Array;
		
		public static var heng:Array;
		
		public static var zhong:Array;
		
		public static var configObj:Object;
	}
}