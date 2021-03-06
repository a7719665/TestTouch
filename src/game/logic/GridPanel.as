package game.logic
{
	import com.data.GridVO;
	import com.evt.GameEvent;
	
	import game.logic.item.RectItem;
	import game.ui.view.GridPanelUI;
	import game.ui.view.RectItemUI;
	
	import manager.AlertManager;
	
	import morn.core.handlers.Handler;
	
	public class GridPanel extends GridPanelUI
	{
		public function GridPanel()
		{
			super();
			list.renderHandler = new Handler(listHandler);//自定义渲染方式

			this.addEventListener("rectItemSelect",rectItemSelect,true);
		}
		
		public function rectItemSelect(evt:GameEvent):void{
			resetNum();
			var item:RectItem = evt.data as RectItem;
			
			getNext(item);
		}
		
		
		private var hengIndexArr:Array;
		private var zhongIndexArr:Array;
		private var listSize:int = 10;
		public static var lastIndex:int;
		private function getNext(item:RectItem):void{
			var index:int = item.index;
			hengIndexArr =[];
			zhongIndexArr =[];
			var beishu:int = index / listSize;
			var hengMax:int = (beishu+1) * listSize ;
			var hengMin:int = int(index/listSize) * listSize;
			if(lastIndex==index || lastIndex==0 || index == lastIndex+1 || index == lastIndex-1 ){
				/**横着*/
				for(var i1:int=index;i1>=hengMin;i1--){
					if(list.array[i1].answer != "0"){
						hengIndexArr.push(i1);
					}else{
						break;
					}
				}
				for(var i:int=index;i<hengMax;i++){
					if(list.array[i].answer != "0"){
						if(hengIndexArr.indexOf(i) < 0)
							hengIndexArr.push(i);
					}else{
						break;
					}
				}
			}
			if(lastIndex==index || lastIndex==0 || index == lastIndex+listSize || index == lastIndex-listSize ){
				/**纵*/
				for(var j1:int=index;j1>=0;j1-=listSize){
					if(list.array[j1].answer != "0"){
						if(zhongIndexArr.indexOf(j1) < 0 && hengIndexArr.indexOf(j1) < 0)
							zhongIndexArr.push(j1);
					}else{
						break;
					}
				}
				for(var j:int=index;j<list.array.length;j+=listSize){
					if(list.array[j].answer != "0"){
						if(zhongIndexArr.indexOf(j) < 0 && hengIndexArr.indexOf(j) < 0)
							zhongIndexArr.push(j);
					}else{
						break;
					}
				}
				
			}
			trace("lastIndex:"+lastIndex+" index:"+index);
			lastIndex = index;
		
			showAnswerSelected(zhongIndexArr);
			showAnswerSelected(hengIndexArr);
		}
		
		public function showSelectAnswer():void{
			showAnswer(zhongIndexArr);
			showAnswer(hengIndexArr);
		}
		
		public function setList(listData:Array):void{
			list.array =listData ;
		}
		
		private function listHandler(item:RectItem,index:int):void{
			if (index < list.length) {
				item.setData(list.array[index],index);
			}
		}
		
		public function showAnswer(arr:Array):void{
			for(var i:int=0;i<arr.length;i++){
				var rectitem:RectItem = list.content.getChildAt(arr[i]) as RectItem;
				rectitem.showAnswer();
			}
		}
		
		public function showAnswerSelected(arr:Array):void{
			for(var i:int=0;i<arr.length;i++){
				var rectitem:RectItem = list.content.getChildAt(arr[i]) as RectItem;
				rectitem.showAnswerClip();
			}
		}
		/**把当前选中的置回去*/
		public function resetNum():void{
			for(var i:int=0;i<list.array.length;i++){
				var rectitem:RectItem = list.content.getChildAt(i) as RectItem;
				rectitem.showNum();
			}
		}
	}
}