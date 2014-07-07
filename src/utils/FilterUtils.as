package utils
{
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * 滤镜【禁止实例化】
	 */
	public class FilterUtils extends BaseUtils
	{
		public function FilterUtils()
		{
			throw new Error("FilterUtils can not be Instantiated!");
		}
		
		public static function get grayFilter() : ColorMatrixFilter
		{
			return new ColorMatrixFilter( [ 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0 ] );
		}
		
		public static function get soulFilter() : ColorMatrixFilter
		{
			return new ColorMatrixFilter( [ 0.3086, 0.2, 0.082, 0, 0, 0.3086, 0.2, 0.082, 0, 0, 0.3086, 0.2, 0.082, 0, 0, 0, 0, 0, 1, 0 ] );
		}
		
		public static function get innerGlowFilter() : GlowFilter 
		{
			return new GlowFilter( 0xff00, 1.0, 4, 4, 4, 1,  true );
		}
		
		public static function get glowFilter() : GlowFilter 
		{
			return new GlowFilter( 0xff00, 1.0, 4, 4, 4, 1, false );
		}
		
		public static function get textGlowFilter() : GlowFilter
		{
			return new GlowFilter( 0xff00, 1, 3, 3, 5, 1, false );
		}
		
		public static function get blurFilter() : BlurFilter		
		{
			return new BlurFilter( 3, 3, 1 );
		}
		
		public static function get bevelFilter() : BevelFilter
		{
			return new BevelFilter( 1, 45, 0xf0f0f0, 1.0, 0x808080, 1.0, 2, 2, 2, 2, BitmapFilterType.INNER );
		}
	}
}