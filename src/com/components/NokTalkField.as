package com.eelpo.components
{
	import com.eelpo.event.ChatEvent;
	import com.eelpo.util.CharUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 图文显示框
	 * @author 闪刀浪子
	 * 使用方法：
	 */
	public class NokTalkField extends Sprite
	{
		private var _tf:TextField;
		private var _tfMask:Sprite;
		private var _faceContainer:Sprite;
		
		private var _maskWidth:Number;
		private var _maskHeight:Number;
		
		private var _textFormat:TextFormat;
		private var _leading:Number
		private var _textColor:uint;
		private var _alpha:Number;
		
		private var mcScrollButton:Sprite;
		
		private var mcScrollLine:Sprite;
		
		private var _clickBool:Boolean;
		private var _appDomain:ApplicationDomain;
		private var rect:Rectangle;
		private var faceTip:Array;
		/*["/惊喜 ","/坏笑 ","/色 ","/淡定 ","/亲亲 ","/流泪 ","/害羞 ","/禁言 ","/呼呼 ","/哈欠 ",
		"/委屈 ","/生气 ","/满意 ","/呲牙 ","/微笑 ","/晕 ","/帅 ","/撒娇 ","/吐 ","/偷笑 ",
		"/口哨 ","/无语 ","/鄙视 ","/尴尬 ","/无所谓 ","/惊讶 ","/汗 ","/高兴 ","/加油 ",
		"/挣扎 ","/疑问 ","/嘘 ","/呆 ","/困 ","/拜拜 ","/雷 ","/强 ","/弱 ","/咖啡 ","/吃饭 ",
		"/电话 ","/囧 ","/斜视 ","/男 ","/女 "];*/
		private var cReg:RegExp=/([\/])([\u4E00-\u9FA5]+)(\s)/g;
		
		/**
		 * 构造函数
		 * @param	width	图文宽度
		 * @param	height  图文框高度
		 * @param	leading  显示的文本行的行间距
		 * @param	appDomain  包含"facexx"的程序域
		 * @param	textColor	默认文本的颜色，如果没有用<font>标签定义颜色，则使用此颜色
		 * @param	alpha  图文框的背景透明度
		 */
		public function NokTalkField(width:Number, height:Number, appDomain:ApplicationDomain = null,
								  leading:Number=2,textColor:uint=0xeeeeee,alpha:Number=0) 
		{
			_maskWidth = width;
			_maskHeight = height;
			_leading = leading;
			_textColor = textColor
			_alpha = alpha;
			_appDomain = appDomain==null?ApplicationDomain.currentDomain:appDomain;
			
			var str:String = App.lang.getLang("chatFaces");
			faceTip = str.split(",");
			
			initView()
			initEvent();
		}
		
		public function get tf():TextField
		{
			return _tf;
		}
		
		public function set tf(value:TextField):void
		{
			_tf = value;
		}
		
		override public function set height(value:Number):void
		{
			_maskHeight=value;
			createBK(_maskWidth,_maskHeight);
			_tfMask.height=value;
			rect.height=value;
			_faceContainer.scrollRect = rect;
		}
		
		private function initView():void
		{
			_tfMask = new Sprite();
			addChild(_tfMask);
			createBK(_maskWidth,_maskHeight);
			createMask();
			createTF();
			createFaceContainer();
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}
		
		private function onMouseWheelHandler(e:MouseEvent):void 
		{
			if(_tf.height>_maskHeight)
			{
				maskY -= (e.delta * 3.0);
				dispatchEvent(new Event(ChatEvent.CHAT_SCROLL));
			}
		}
		
		private function createBK(w:Number,h:Number):void
		{
			graphics.clear();
			graphics.beginFill(0, _alpha);
			graphics.drawRect( 0, -2, w, h);
			graphics.endFill();
		}
		
		private function createMask():void
		{	
			_tfMask.graphics.clear();
			_tfMask.graphics.beginFill(0x000000);
			_tfMask.graphics.drawRect(0, 0, _maskWidth, _maskHeight);
			_tfMask.graphics.endFill();
			
		}
		
		private function createTF():void
		{
			_textFormat = new TextFormat;
			_textFormat.color=_textColor;
			_textFormat.size = 12;
			_textFormat.letterSpacing = 0.75;
			_textFormat.leading = _leading;
			_textFormat.font="Tahoma";
			_textFormat.kerning=true;
			_tf = new TextField();
			_tf.textColor = 0xffffff;
			_tf.width = _maskWidth;
			
			_tf.defaultTextFormat = _textFormat;
			_tf.selectable = false;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.autoSize = "left";
			//_tf.filters = [new GlowFilter(0x0A383E, 0.95, 2, 2, 8)];
			//_tf.filters=[FilterUtils.glowFilter];
			_tf.mouseWheelEnabled = false;
			_tf.addEventListener(TextEvent.LINK,linkHandler,false,0,true);
			addChild(_tf);
			this.mask = _tfMask;
		}
		
		/**文本点击事件派发*/
		private function linkHandler(e:TextEvent):void
		{
			_clickBool=true;
			var arr:Array=e.text.split("_");
			//this.dispatchEvent(new TextClickEvent(TextClickEvent.TEXTCLICKEVENT,arr[0],arr[1],arr[2]));
		}
		
		private function createFaceContainer():void
		{
			_faceContainer = new Sprite();
			rect=new Rectangle(0, 0, _maskWidth, _maskHeight+10);
			_faceContainer.scrollRect = rect;
			addChild(_faceContainer);
		}
		
		private function clearFaceContain():void
		{
			while (_faceContainer.numChildren > 0)
			{
				_faceContainer.removeChildAt(0);
			}
		}
		
		public function get faceContainer():Sprite{
			return _faceContainer;
		}
		
		/**
		 * 聊天显示框
		 * @param	str 必须为htmlText格式
		 */
		public function setText(str:String):void
		{
			_tf.text = "";
			_tf.defaultTextFormat = _textFormat;
			var faceArr:Array = [];
			clearFaceContain();
			//保存表情符的编号并替换为空格,此处可以根据你的表情数量来修改正则表达式
			//表情素材的导出类名规则为——face01-face05
			var face:Array = str.match(CharUtil.matchReg);
			if (face != null)
			{
				faceArr = faceArr.concat(face);
			}
			//注意这里是将表情编号替换为全角的空格，所以记住你的输入框要禁止玩家输入全角空格
			//需要替换的内容是：*01 - *09
			str = str.replace(CharUtil.matchReg, "<font size='20'>　</font>");
			_tf.htmlText = str;
			_tf.height;
			
			//记录空格的索引号
			var text:String = _tf.text;
			var indexArr:Array = [];
			for (var index:int = 0; index < text.length; index++)
			{
				if (text.charAt(index) == "　")
				{
					indexArr.push(index);
				}
			}
			_tf.height;
			for (var j:uint = 0; j < indexArr.length; j++)
			{   
				var str:String;
				var tempPos:Rectangle = _tf.getCharBoundaries(indexArr[j]);
				str=faceArr[j].substr(1, 2);
				//var linkClass:Class = _appDomain.getDefinition("face" + faceArr[j].substr(1, 2)) as Class;
//				var linkClass:MovieClip =StyleFactory.getInstance().getEffect(StyleFactory.SMILE,"Smile" + str) as MovieClip;
//				if (linkClass != null&&tempPos!=null)
//				{
//					//					var mc:Bitmap = new linkClass as Bitmap;
//					_faceContainer.addChild(linkClass);
//					linkClass.x = tempPos.x+2;
//					linkClass.y = tempPos.y+4;
//				}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 设置文本
		 * @param	arr 频道数组
		 */
		public function setMultiText(arr:Array):void
		{
			if (arr == null) return;
			_tf.text = "";
			_tf.defaultTextFormat = _textFormat;
			var faceArr:Array = [];
			clearFaceContain();
			maskY=0;
			var allStr:String=""
			var num:int=arr.length;
			for (var i:uint = 0; i < num; i++)
			{
				var str:String = arr[i]+"\n";
				var face:Array = str.match(cReg);
				//				if (face != null)
				//				{
				//					faceArr = faceArr.concat(face);
				//				}
				for(var k:int=0;k<face.length;k++)
				{
					if(faceTip.indexOf(face[k])>-1)
					{
						//var reg:RegExp=
						faceArr.push(face[k]);
						str = str.replace(face[k], "<font size='20'>　</font>");
					}
				}
				//				str = str.replace(ChatStrUtil.matchReg, "<font size='22'>　</font>");
				allStr += str;
			}
			_tf.htmlText = allStr;
			_tf.height=_tf.textHeight+5;
			
			//记录空格的索引号
			var text:String = _tf.text;
			var indexArr:Array = [];
			for (var index:int = 0; index < text.length; index++)
			{
				if (text.charAt(index) == "　")
				{
					indexArr.push(index);
				}
			}
			_tf.height;
			for (var j:uint = 0; j < indexArr.length; j++)
			{
				var s:String;
				var tempPos:Rectangle = _tf.getCharBoundaries(indexArr[j]);
				
				//				s=faceArr[j].substr(1, 2);
				//				var linkClass:Class = _appDomain.getDefinition("Smile" + faceArr[j].substr(1, 2)) as Class;
				var faceIndex:int=faceTip.indexOf(faceArr[j]);
				if(faceIndex>-1)
				{
					s=(faceIndex+1)<10?"0"+(faceIndex+1).toString():(faceIndex+1).toString();
				}
//				var linkClass:MovieClip = StyleFactory.getInstance().getEffect(StyleFactory.SMILE,"Smile" + s) as MovieClip;
//				if (linkClass != null&&tempPos!=null)
//				{
//					//					var mc:Bitmap = new linkClass as Bitmap;
//					_faceContainer.addChild(linkClass);
//					//					if(s=="44"||s=="45")
//					//					{
//					//						linkClass.x = tempPos.x+4;
//					//						linkClass.y = tempPos.y+4;
//					//					}else
//					//					{
//					//						linkClass.x = tempPos.x+1;
//					//						linkClass.y = tempPos.y+4;
//					//					}
//					linkClass.x = tempPos.x;
//					linkClass.y = tempPos.y+2;
//				}
				
			}
			dispatchEvent(new Event(Event.CHANGE));			
		}
		
		/* INTERFACE game.ui.list.IScrollElement */
		
		public function get maskX():Number 
		{
			return _faceContainer.scrollRect.x;
		}
		
		public function set maskX(val:Number):void
		{
			var rec:Rectangle = _faceContainer.scrollRect;
			rec.x = val;
			_tf.x = -val;
			_faceContainer.scrollRect = rec;
			
		}
		
		public function get maskY():Number 
		{
			return _faceContainer.scrollRect.y;
		}
		
		public function set maskY(val:Number):void
		{
			var rec:Rectangle = _faceContainer.scrollRect;
			if (val < 0) val = 0;
			else if (val >=maxScroll) val = maxScroll;
			_tf.y = -val;
			rec.y = val;
			_faceContainer.scrollRect = rec;
		}
		
		public function get minScroll():Number 
		{
			return 0;
		}
		
		public function get maxScroll():Number 
		{
			if (_tf.height <= _tfMask.height) return 0;
			else return _tf.height - _tfMask.height;
		}
		
		public function set clickBool(bool:Boolean):void
		{
			_clickBool=bool;
		}
		
		public function  get clickBool():Boolean
		{
			return _clickBool;
		}
		
	}
}