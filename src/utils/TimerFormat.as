package utils
{
	public class TimerFormat
	{
		public function TimerFormat()
		{
		}
		
		public static function setTimeText($time:int):String
		{
			if($time == 0)
				return "";
			var day:String = String(int($time/(3600*24)));
			var hour:String;
			var leftday:int=int($time%(3600*24));
			hour = String ( int(leftday/3600));
			var min:String;
			var timeTips:String;
			var lefthour:int=int($time%3600);
			min = String( int(lefthour/60)) ;
			var sec:String = String(int( $time%60)) ;
			
			if( min.length == 1 )
				min = "0" + min;
			if( sec.length == 1 )
				sec = "0" + sec;	
			if(int(day)<=0){
				if(int(hour)>0){
					if( hour.length == 1 )
						hour = "0" + hour;
					timeTips = hour+":" + min + ":" + sec + "  ";	
				}else
					timeTips = min + ":" + sec + "  ";	
			}else{
				if(int(hour)>0){
					if( hour.length == 1 )
						hour = "0" + hour;
					timeTips = day+ App.lang.getLang("day")+ hour+":" + min + ":" + sec + "  ";	
				}else
					timeTips = day+ App.lang.getLang("day") + min + ":" + sec + "  ";	
			}
//			if(playCallback!=null)
//				playCallback(timeTips,leftTimeCount,_initTime);
//			else{
//				if(textF)
//					textF.setText(timeTips);
//			}
			return timeTips;
		}
	}
}