package game.logic
{
	import com.data.GridVO;
	
	import game.ui.view.ZcrScreenUI;
	
	import manager.AlertManager;
	
	import utils.ColorTextUtils;
	import utils.TimerFormat;
	import utils.TimerUtils;
	
	public class ZcrScreen extends ZcrScreenUI
	{
		private var timer:TimerUtils;

		public function ZcrScreen()
		{
			super();
			setLeftTxt();
			setRightTxt();
			setList();
			setTimer();
			
			setTips();
		}
		
		private function setLeftTxt():void{
			var str:String="";
			var arr:Array = Global.heng;
			for(var i:int=0;i<arr.length;i++){
				str += (ColorTextUtils.setColorFont(arr[i],ColorTextUtils.normalS)+"<br>");
			}
			leftTxt.text=str;
		}
		private function setRightTxt():void{
			var str:String="";
			var arr:Array = Global.zhong;
			
			for(var i:int=0;i<arr.length;i++){
				str += (ColorTextUtils.setColorFont(arr[i],ColorTextUtils.normalS)+"<br>");
			}
			rightTxt.text=str;
		}
		
		private function setList():void{
			var listData:Array=[];
			var arr:Array = Global.question;
			var arr2:Array = Global.answer;
			if(arr.length != arr2.length){
				AlertManager.showByName(AlertOk,null,"answer和question数组不一样");
			}else{
				for(var i:int=0;i<arr.length;i++){
					var gridvo:GridVO = new GridVO();
					gridvo.question = arr[i];
					gridvo.answer = arr2[i];
					listData.push(gridvo);
				}
			}
			grid.setList(listData) ;
		}
		
		
		private function setTimer():void{
			timer = new TimerUtils(1000,5);
			timer.registerCallback(progressHandle,completeHandle);
			timer.start();
		}
		private function progressHandle():void{
			timeTxt1.text = TimerFormat.setTimeText(timer.repeatCount-timer.currentCount);
			timeTxt2.text = TimerFormat.setTimeText(timer.repeatCount-timer.currentCount);
		}
		private function completeHandle():void{
		}
		
		private function setTips():void{
//			tipTxt.text = Global.heng[0];
		}
	}
}