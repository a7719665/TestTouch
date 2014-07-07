package game
{
	import com.data.DialogData;
	import com.evt.GameEvent;
	import com.greensock.TweenMax;
	import com.touch.MultTouchEvent;
	
	import game.logic.MainScreen;
	import game.logic.ZcrScreen;
	import game.logic.item.CardItem;
	import game.ui.view.ChooseCardUI;
	
	import manager.LayerManager;
	import manager.ViewManager;
	
	public class ChooseCard extends ChooseCardUI
	{
		private  const TWEENT_WIDTH:int = 120;
		private var itemArr:Array;
		
		private var blackCard:CardItem;
		private var redCard:CardItem;
		
 		public function ChooseCard()
		{
			super();
			this.width = LayerManager.stageWidth;
			this.height = LayerManager.stageHeight;;
			redCard = new CardItem();
			redCard.visible = false;
			this.addChild(redCard);
			redCard.initX = redCard.x = (this.width - redCard.width) * 0.5 - 40;
			redCard.initY = redCard.y = (this.height - redCard.height) * 0.5;
			
			blackCard = new CardItem();
			blackCard.visible = false;
			this.addChild(blackCard);
			blackCard.initX =	blackCard.x = (this.width - blackCard.width) * 0.5 + 40 + blackCard.width;
			blackCard.initY =	blackCard.y = (this.height - blackCard.height) * 0.5;
			
			redCard.addEventListener(MultTouchEvent.GESTURE,testFun);
			blackCard.addEventListener(MultTouchEvent.GESTURE,testFun);
			
			itemArr =[];
			for(var i:int=0;i<6;i++){
				var item:CardItem = new CardItem();
				this.addChild(item);
				item.x = i*20;
				item.y = (this.height - item.height) * 0.5;
				item.initX = item.x;
				item.initY = item.y;
				item.minX = item.x;
				item.maxX = i*(item.width+10);
				itemArr.push(item);
			}
			this.addEventListener("rightTouch",rightTouch,true);
			this.addEventListener("leftTouch",leftTouch,true);	
			this.addEventListener("carditemselect",cardItemSelect,true);	
 		}
		
		private function testFun(evt:MultTouchEvent):void{
			var item:CardItem = evt.currentTarget as CardItem;
			if(item == blackCard){
				if(evt.moveX > 0){
					TweenMax.to(item, 0.5, {x:item.x + 100,y:item.y - 100,onComplete:flyComBlack});
  				}
			}else{
				if(evt.moveX < 0){
					TweenMax.to(item, 0.5, {x:item.x - 100,y:item.y - 100,onComplete:flyComRed});
				}
			}
			 
		}
		private function flyComBlack():void{
			blackCard.visible=false;
			checkSendTimu();
		}
		private function flyComRed():void{
			redCard.visible=false;
			checkSendTimu();
 		}
		
		private function checkSendTimu():void{
			var  bo1: Boolean = TweenMax.isTweening(blackCard);
			var  bo2: Boolean = TweenMax.isTweening(redCard);
			if(!bo1 && !bo2 && !blackCard.visible && !redCard.visible){
				var dialogdata:DialogData = new DialogData();
				dialogdata.className = ZcrScreen;
				ViewManager.me.setView(dialogdata);
			}
		}
		
		private function showBlackRea():void{
			for(var i:int=0;i<6;i++){
				var item:CardItem = itemArr[i];
				item.visible =false;
			}
			blackCard.visible=true;
			redCard.visible=true;
			
		}
		
		private function cardItemSelect(evt:GameEvent):void{
			showBlackRea();
			return;
			
			var evtitem:CardItem = evt.data as CardItem;
			for(var i:int=0;i<6;i++){
				var item:CardItem = itemArr[i];
				if(item != evtitem)
 					item.y = item.initY;
				else
					item.setClick();
			}
		}
		
		
		private function leftTouch(evt:GameEvent):void{
			if(itemArr[1].minX >= itemArr[1].x)
				return;
			this.removeEventListener("rightTouch",rightTouch,true);
			this.removeEventListener("leftTouch",leftTouch,true);
			for(var i:int=1;i<6;i++){
				var item:CardItem = itemArr[i];
 				TweenMax.to(item, 0.5, {x:item.initX,onComplete:resetListen});

			}
			
		}
		
		private function rightTouch(evt:GameEvent):void{
			if(itemArr[1].maxX <= itemArr[1].x)
				return;
			this.removeEventListener("rightTouch",rightTouch,true);
			this.removeEventListener("leftTouch",rightTouch,true);

			for(var i:int=1;i<6;i++){
				var item:CardItem = itemArr[i];
				TweenMax.to(item, 0.5, {x:(i*(item.width+10)),onComplete:resetListen});

			}
		}
		
		/**关闭对话框*/
		public function resetListen():void {
			if(!this.hasEventListener("rightTouch")){
	 			this.addEventListener("rightTouch",rightTouch,true);
				this.addEventListener("leftTouch",leftTouch,true);	
			}
		}
		
	}
}