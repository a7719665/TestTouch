package
{
	import com.FilePath;
	
	import deng.fzip.FZip;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import morn.core.handlers.Handler;
	import morn.core.managers.ResLoader;

	[SWF(frameRate="30", backgroundColor="0x000000")]
	public class Loading extends Sprite
	{
		
		[Embed(source="/assets/roll.swf", symbol='Roll')]
		private var INIT_LOADING:Class;
		
		/**
		 * 加载器
		 */
		private var GAME_LOADING:Class;
		
		private var roll:*;
		
		/**
		 * 配置对象
		 */
		private var configObj:ConfigObj;
		
		/**
		 * config的zip包
		 */
		private var zip:FZip;
		/**
		 * 主文件
		 */
		private var main:Loader;
		
		/**
		 * 加载器文件
		 */
		private var gameLoader:Loader;
		/**
		 * 进度条
		 * */
		protected var loading:*;
		[SWF(frameRate="30",width="1440",height="800", backgroundColor="0x000000")]
		public function Loading()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu=false;
			
			roll=new INIT_LOADING();
			addChild(roll);
			if (roll) {
				roll.x=(stage.stageWidth - 40) / 2;
				roll.y=(stage.stageHeight - 40) / 2;
			}
			// 获取js配置文件
//			var config:Object=ExternalInterface.call("config");
//			configObj=new ConfigObj(config);
			
			App.init(this);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			
			// 加载loading动画
			gameLoader=new Loader();
			gameLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onGameLoadComplete);
			gameLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onGameLoadCompleteError);
			
			gameLoader.load(new URLRequest(/*configObj.swfPath +*/ "resource/loading.swf?" ));
		}
		
		
		private function onGameLoadCompleteError(event:IOErrorEvent):void{
			trace(event.text);
		}
		private function onGameLoadComplete(e:Event):void{
			
			gameLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onGameLoadComplete);
			
			GAME_LOADING=gameLoader.contentLoaderInfo.applicationDomain.getDefinition("SceneLoading") as Class;
			
			if (roll) {
				removeChild(roll);
				roll=null;
			}
			
			var cls:Class=GAME_LOADING;
			loading=new cls();
			
			loading["loading_1"].gotoAndStop(1);
			loading["loading_1"].visible=false;
			loading["loadtxt"].text="";
			loading.x=(stage.stageWidth - loading.width) / 2;
			loading.y=(stage.stageHeight - loading.height) / 2;
			addChild(loading);
			
//			loadMain();
			loadQuestionTxt();
		}
		
		private function loadQuestionTxt():void{
			App.loader.loadTXT(FilePath.QUESTIOIN_ADDRESS+"1/"+"answer.txt" ,new Handler(lc),new Handler(lp));
			App.loader.loadTXT(FilePath.QUESTIOIN_ADDRESS+"1/"+"question.txt" ,new Handler(lc2),new Handler(lp2));
			App.loader.loadTXT(FilePath.QUESTIOIN_ADDRESS+"1/"+"heng.txt" ,new Handler(lc3),new Handler(lp3));
			App.loader.loadTXT(FilePath.QUESTIOIN_ADDRESS+"1/"+"zhong.txt" ,new Handler(lc4),new Handler(lp4));
		}
		
		private function lc3(content:String):void{
			Global.heng = content.split("\r\n");
			checkLoadAnswer();
		}
		
		private function lp3(content:String):void{
			
		}
		private function lc4(content:String):void{
			Global.zhong = content.split("\r\n");
			checkLoadAnswer();
		}
		
		private function lp4(content:String):void{
			
		}
 
		private function lc2(content:String):void{
			Global.question = [];
			content = content.replace(/\r/g, "");
			var arr:Array = content.split("\n");
			for(var i:int=0;i<arr.length;i++){
				var str:String = arr[i];
				var arr3:Array   = str.split(",");
//				Global.question.push(arr3);
				for(var j:int=0;j<arr3.length;j++){
					Global.question.push(arr3[j]);
				}
 			}
			var arr4:Array = Global.question;
			checkLoadAnswer();
		}
		
		private function lp2(content:String):void{
			
		}
		
		private function lc(content:String):void{
			Global.answer = [];
//			content = content.replace("\r","");
			content = content.replace(/\r/g, "");
			var arr:Array = content.split("\n");
			for(var i:int=0;i<arr.length;i++){
				var str:String = arr[i];
				var arr3:Array   = str.split(",");
//				Global.answer.push(arr3);
				for(var j:int=0;j<arr3.length;j++){
					Global.answer.push(arr3[j]);
				}
			}
						var arr4:Array = Global.answer;
			checkLoadAnswer();
		}
		
		private function checkLoadAnswer():void{
			if(Global.answer && Global.question && Global.heng && Global.zhong)
				loadMain();
		}
		
		private function lp(content:String):void{
			
		}
		
		private function onLoadTxtComplete(/*content:Object*/):void{
			
		}
		
		private function onLoadTxtProgress(value:Number):void{
			var rate:int=value*100;
			loading["loading_1"].visible=true;
			loading["loading_1"].gotoAndStop(rate);
			var rateload:Number;
			
			loading["loadtxt"].text=App.lang.getLang("jiazaiyangshi"),+rate+"%";
		}
		
		private function onStageResize(e:Event=null):void {
			if (roll) {
				roll.x=(stage.stageWidth - 40) / 2;
				roll.y=(stage.stageHeight - 40) / 2;
			}
			if(main){
				main.content["onStageResize"]();
			}
		}
		
		/**
		 * 加载主文件
		 */
		private function loadMain():void{
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMainComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onMainProgress);
			loader.load(new URLRequest(/*configObj.swfPath + */"main.swf"));
		}
		
		
		private function onMainProgress(e:ProgressEvent):void{
			loading["loading_1"].visible=true;
			var rate:int=int(e.bytesLoaded / e.bytesTotal * 100);
			loading["loading_1"].gotoAndStop(rate);
			var rateload:Number;
			
			loading["loadtxt"].text="加载主文件     "+rate+"%";
		}
		
		private function onMainComplete(e:Event):void{
			(e.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE,onMainComplete);
			(e.currentTarget as LoaderInfo).removeEventListener(ProgressEvent.PROGRESS,onMainProgress);
			main = (e.currentTarget as LoaderInfo).loader;
//			main.content["configObj"]=configObj;
			main.content["GAME_LOADING"]=GAME_LOADING;
			main.content["loading"]=loading;
//			main.content["GAME_LOADING"]=GAME_LOADING;
			this.addChild(main);
			loadCss();	
		}
		
		
		private function loadCss():void{
			App.loader.loadAssets([FilePath.MAINSWF,FilePath.TEMPSWF,FilePath.MCSWF,FilePath.COMPSWF],new Handler(onLoadCssComplete),new Handler(onLoadCssProgress));
		}
		
		private function onLoadCssComplete():void{
			onStageResize();
			
			main.content["createUI"]();
//			main.content["SocketCon"]();
		}
		private function onLoadCssProgress(value:Number):void{
			var rate:int=value*100;
			loading["loading_1"].visible=true;
			loading["loading_1"].gotoAndStop(rate);
			var rateload:Number;
			
			loading["loadtxt"].text=App.lang.getLang("jiazaiyangshi"),+rate+"%";
		}
	}
}


/**js as3对象*/
class ConfigObj{
	
	public function ConfigObj(config:Object){
		for(var k:String in config){
			if(this.hasOwnProperty(k)){
				this[k]=config[k];
			}
		}
	}
	
	public static const LOCALHOST:String="localhost";
	
	public static const BAIDU:String="baidu";
	
	public static const WAN32:String="32wan";
	
	public static const TENCENT:String="tencent";
	
	/**serverId*/
	public var serverId:String;
	/**serverUid*/
	public var serverUid:String;
	/**全局服务器Id---充值使用的服务器区别标识*/
	public var serverGid:String;
	/**serverSid*/
	public var serverSid:String;
	/**ip*/
	public var serverHost:String;
	/**端口*/
	public var serverPort:int;
	/**平台标示*/
	public var serverPlatform:String;
	/**1:显示侧边栏，其它不显示*/
	public var sidebar:int;
	/**是否同过防沉迷  
	 * 0-没有通过需要验证，<br/>
	 * 1-通过，无需验证
	 **/
	public var addiction:int=1;
	/**登录名*/
	public var userName:String;
	/**登录时间戳*/
	public var timeStamp:String;
	/**密钥*/
	public var sign:String;
	/**资源地址*/
	public var swfPath:String;
	/**bbs论坛地址*/
	public var bbsWebsite:String;
	/**官方首页*/
	public var gameWebsite:String;
	/**客服地址*/
	public var serviceWebsite:String;
	/**充值地址*/
	public var rechargeWebsite:String;
	/**防沉迷地址*/
	public var addictionWebsite:String;
	/**参数*/
	public var parameters:String;
}