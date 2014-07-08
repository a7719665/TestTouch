	package game.logic.item
{
	import com.constants.RectConstants;
	import com.data.GridVO;
	import com.evt.GameEvent;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchPhase;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.ui.view.RectItemUI;
	
	public class RectItem extends RectItemUI
	{
		/**有题目文字的敌方*/
		public var WORD_CLIP:int = 2;
		/**什么都没有，不是数字，也不是答案*/
		public var NOTHING_CLIP:int = 1;
		/**选中了*/
		public var SELECT_CLIP:int = 0;
		
		private var _index:int;
		private var _gridVO:GridVO;
		public function RectItem()
		{
			super();
			btnclip.frame = NOTHING_CLIP;
			label1.textField.mouseEnabled=false;
			btnclip.mc.mouseEnabled=false;
			btnclip.mc.mouseChildren=false;
			
			this.addEventListener(MultTouchEvent.TOUCH,onTouch);

 		}
		
		private function onTouch(event:MultTouchEvent):void{
//			if(event.touchType == MultTouchPhase.TOUCH_MOVE || event.touchType == MultTouchPhase.TOUCH_BEGAN ){
//				this.dispatchEvent(new MultTouchEvent(MultTouchEvent.SELECT));
				onClick();
				trace(event.touchType)
//			}
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function setData(value:GridVO,$index:int):void{
			_gridVO = value;
			_index = $index;

			if(_gridVO.answer != "0"){
				btnclip.frame = WORD_CLIP;				
				this.addEventListener(MouseEvent.CLICK,onClick);
			}
			setQuestionTxt();
		}
		/**高亮并且显示答案*/
		public function showAnswer():void{
			btnclip.frame = SELECT_CLIP;
			if(_gridVO.answer !="0"){
				label1.text = _gridVO.answer;
			}
		}
		
		private function setQuestionTxt():void{
			if(_gridVO.question !="0"){
				label1.text = _gridVO.question;
			}else{
				label1.text = "";
			}
		}
		/**只做高亮，答案不显示。用在选题的时候*/
		public function showAnswerClip():void{
			btnclip.frame = SELECT_CLIP;
		}
		
		public function showNum():void{
			if(_gridVO.answer != "0"){
				btnclip.frame = WORD_CLIP;
				setQuestionTxt();
			}
 		}
		
		private function onClick(evt:Event=null):void{
			if(_gridVO && _gridVO.answer != "0"){
				this.dispatchEvent(new GameEvent("rectItemSelect",this));
			}
		}
		
		
		public function destroy():void{
			
		}
	}
}