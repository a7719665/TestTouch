package game.logic
{
	import com.data.GridVO;
	import com.evt.Dispatcher;
	import com.evt.GameEvent;
	
	import flash.utils.Dictionary;
	
	import game.logic.item.RectItem;
	import game.ui.view.MainScreenUI;
	
	import manager.AlertManager;
	
	import morn.core.handlers.Handler;
	
	import net.DataPacket;
	import net.DataPacketResult;
	import net.EPSocket;
	
	import utils.ColorTextUtils;
	import utils.TimerFormat;
	import utils.TimerUtils;
	
	public class MainScreen extends MainScreenUI
	{
		private var timer:TimerUtils;
		public function MainScreen()
		{
			super();
			setLeftTxt();
			setRightTxt();
			setList();
			setTimer();
			
			setTips();
//			getOpen();
			
		}
		
		public function getOpen():void{
			var dic:Dictionary = new Dictionary();
			dic.Time=Global.configObj.timeStamp.toString();
			dic.Name=Global.configObj.userName;
			dic.Param=Global.configObj.parameters;
			dic.Sign=Global.configObj.sign;
			dic.ServerId=Global.configObj.serverId;
			dic.ServerUid=Global.configObj.serverUid;
			dic.ServerGid=Global.configObj.serverGid;
			dic.ServerSid=Global.configObj.serverSid;
			
			EPSocket.me.sendData(/*LoginAction.LOGIN*/101, [dic]);
			Dispatcher.me.addEventListener("101",getOpenBack);
			
//			EPSocket.me.sendData(NetCode.TESTCODE);
//			Dispatcher.me.addEventListener(NetCode.TESTCODE.toString(),getOpenBack);
		}
		
		//打开 
		private function getOpenBack(event:GameEvent):void{
			
			Dispatcher.me.addEventListener("401",onBagOpen);
			EPSocket.me.sendData(401);
		}
		
		private function onBagOpen(event:GameEvent):void{
			var acid:int = event.data.actionId;
			var d:DataPacket = event.data.dataPacket;
			if(d.result == DataPacketResult.SUCC){
				
			}
		}
		
		
		private function setLeftTxt():void{
			var str:String="";
			var arr:Array = Global.heng;
			for(var i:int=0;i<arr.length;i++){
				str += (ColorTextUtils.setColorFont(arr[i],ColorTextUtils.normalS)+"<br>");
			}
			timeTxt1.text=str;
		}
		private function setRightTxt():void{
			var str:String="";
			var arr:Array = Global.zhong;

			for(var i:int=0;i<arr.length;i++){
				str += (ColorTextUtils.setColorFont(arr[i],ColorTextUtils.normalS)+"<br>");
			}
			timeTxt2.text=str;
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
			tipTxt.text = Global.heng[0];
		}
		
		
	}
}