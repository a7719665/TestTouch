package manager
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import manager.ITip;
	
	import morn.core.handlers.Handler;

	public class ToolTipManager
	{
		private static var obj:Dictionary=new Dictionary();
		
		public function ToolTipManager()
		{
		}
		
		public static function getNewHandle(cls:Class,obj:Object):Handler{
			return new Handler(show,[cls,obj]);
		}
		
		public static function show(cls:Class,obj:Object):void
		{
			var tooltip:ITip = getTargetPanel(cls);
			tooltip.setData(obj);
			App.tip.addChild(tooltip as DisplayObject);
		}
		
		
		private static function getTargetPanel(cls:Class):ITip
		{
			var toolTip:ITip;
			if(!obj[cls]){
				toolTip=new cls();
				obj[cls] = toolTip;
			}else{
				toolTip = obj[cls];
			}
			return toolTip;
		}
	}
}