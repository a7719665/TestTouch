package manager
{
 	
	import flash.utils.Dictionary;
	
	import morn.core.components.View;
	
	public class AlertManager
	{
		public function AlertManager()
		{
		}
		private static var dic:Dictionary=new Dictionary;
		
		/**显示点击确定信息*/
		public static function showByName(cls:Class, closeHandler:Function=null,...args):void
		{
			var alert:IAlert=new cls();
			alert.init(args);
			dic[cls] = alert;
			LayerManager.me.topSpriteAdd(alert as View);
		}
		
		//		public static function showHp(
		
		public static function getWinByClass(cls:Class):IAlert{
			return   dic[cls];
		}
		
	}
}