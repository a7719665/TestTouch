package game.logic.item
{
	import com.evt.GameEvent;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	
	import game.ui.view.item.CardItemUI;
	
	public class CardItem extends CardItemUI
	{
		private var _initY:int;
		private var _initX:int;
		private var _minX:int;
		private var _maxX:int;
		public function CardItem()
		{
			super();
			
			this.addEventListener(MultTouchEvent.GESTURE,testFun);
			this.addEventListener(MultTouchEvent.SELECT,touchClick);
			
			
			// 5 - 检查Key
			new MultTouchHelper(this,MultTouchHelper.MULT_ALL);
		}
		
		public function get initY():int
		{
			return _initY;
		}

		public function set initY(value:int):void
		{
			_initY = value;
		}

		public function get initX():int
		{
			return _initX;
		}

		public function set initX(value:int):void
		{
			_initX = value;
		}

		public function get maxX():int
		{
			return _maxX;
		}

		public function set maxX(value:int):void
		{
			_maxX = value;
		}

		public function get minX():int
		{
			return _minX;
		}

		public function set minX(value:int):void
		{
			_minX = value;
		}

		public function setClick():void{
			if(this.y < this._initY){
				this.y +=40;
				this.scale = 1;
			}else{
				this.scale = 1.5;
				this.y -=40;
			}
		}

		private function touchClick(evt:MultTouchEvent):void{
			if(this.x == this._maxX){
				
				this.dispatchEvent(new GameEvent("carditemselect",this));
			}
			

		}
		private function testFun(evt:MultTouchEvent):void{
			if(evt.moveX > 0){
				this.dispatchEvent(new GameEvent("rightTouch",this));
			}
			if(evt.moveX < 0){
				this.dispatchEvent(new GameEvent("leftTouch",this));
			}
			//				sp.x += evt.moveX;
			//				sp.y += evt.moveY;
			//				sp.scaleX = sp.scaleY *= evt.scale;
			//				
			//				sp.rotation += evt.rota;
		}
	}
}