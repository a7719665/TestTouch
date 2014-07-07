package utils
{
	public class ColorTextUtils
	{
		
		/**金色*/
		public static var GOLDEN:int=0xF2D272;
		public static var blueWhite:int = 0x77CCAA;
		
		public static var NORMAL:int=0xeee390;
		
		public static var goldenS:String="#F2D272";
		public static var blueS:String="#00FFFF";
		public static var orangeS:String="#FFFF00";
		public static var redS:String="#FF0000";
		public static var yellowS:String="#FFFF00";
		public static var greenS:String="#00FF00";
		public static var whiteS:String="#ffffff";
		public static var brownS:String="#FF9226";
		public static var normalS:String="#eee390";
		public static var purpleS:String="#ff00ff";
		
		public static var blueWhiteS:String = "#77CCAA";
		public function ColorTextUtils()
		{
		}
		/**
		 *  一行文字，多个混杂的 颜色 (不会中间穿插)
		 * */
		public static function setColorFontArr($textArr:Array,$colorArr:Array=null,$size:int=12,$bold:Boolean=false):String{
			var str:String="";
			if(!$colorArr)
				$colorArr=[whiteS,normalS];
			for(var i:int=0;i<$textArr.length;i++){
				str+="<font color='"+$colorArr[i]+"'"+" size='"+$size+"'>"+$textArr[i]+"</font>";
			}
			
			if($bold)
				str=setBold(str);
			return str;
		}
		/**
		 *  一行文字 在中间穿插另外一个颜色的
		 * */
		public static function setColorFontArrAdd($text:String,$addText:String,$color:String,$addColor:String,$addIndex:int,$size:int=12):String{
			var frontStr:String=$text.slice(0,$addIndex);
			var backStr:String=$text.slice($addIndex);
			
			var addStr:String="<font color='"+$addColor+"'"+" size='"+$size+"'>"+$addText+"</font>";
			var str1:String="<font color='"+$color+"'"+" size='"+$size+"'>"+frontStr+"</font>";
			var str2:String="<font color='"+$color+"'"+" size='"+$size+"'>"+backStr+"</font>";
			
			var str:String=str1+addStr+str2;
			return str;
		}
		
		/**
		 *  颜色 + 大小
		 * */
		public static function setColorFont($text:String,$color:String="#ffffff",$size:int=12):String{
			var str:String="<font color='"+$color+"'"+" size='"+$size+"'>"+$text+"</font>";
			return str;
		}
		/**
		 *  颜色 + 大小 + 换行
		 * */
		public static function setColorFontNewline($text:String,$color:String,$size:int=12):String{
			var str:String="<font color='"+$color+"'"+" size='"+$size+"'>"+$text+"</font>";
			str=str+"<br>";
			return str;
		}
		/**
		 * 粗体
		 * */
		public static function setBold($text:String):String{
			var str:String="<b>"+$text+"</b>";
			return str;
		}
		
		/**
		 * 粗体 + 颜色 +大小
		 * */
		public static function setBoldColorSize($text:String,$size:int=12,$color:String="#FCF40C"):String{
			var str:String="<font color='"+$color+"'"+" size='"+$size+"'>"+$text+"</font>";
			str="<b>"+str+"</b>";
			return str;
		}
		
		/**
		 * 粗体 + 颜色 +大小+换行
		 * */
		public static function setBoldColorSizeNewline($text:String,$size:int=12,$color:String="#FCF40C"):String{
			var str:String="<font color='"+$color+"'"+" size='"+$size+"'>"+$text+"</font>";
			str="<b>"+str+"</b>";
			str=str+"<br>";
			return str;
		}
		
		
		/**
		 * 设置行距
		 * */
		public static function setLeading($text:String,$leading:int):String{
			var str:String="<textformat leading='"+$leading+"'>"+$text+"</textformat>";
			return str;
		}
		/**
		 * 换行
		 * */
		public static function newLine($text:String):String{
			var str:String=$text+"<br>";
			return str;
		}
		
//		public static function getHrefFormat($text:String,$color:String="#FCF40C",$id:int=0):String
//		{
//			var str:String="<a href='event:"+TextClickEvent.PLAYERCLICK+"_"+$id+"_"+$text+"'>"+"<font  color='"+$color+"'><u>"+$text+"</u>"+"</font></a>";
//			return str;
//		}
	}
}