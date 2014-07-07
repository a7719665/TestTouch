package
{
	import com.FilePath;
	import com.data.DialogData;
	import com.touch.MultTouchEvent;
	import com.touch.MultTouchHelper;
	import com.touch.MultTouchManager;
	import com.touch.extension.TuioModule;
	
	import deng.fzip.FZip;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import game.logic.BgWin;
	import game.logic.MainScreen;
	
	import manager.LayerManager;
	import manager.ViewManager;
	
	import net.BaseSocket;
	import net.EPSocket;
	import net.SocketEvent;
	import net.WriteBuffer;

	[SWF(frameRate="30",width="1440",height="800", backgroundColor="0x000000")]
	public class Main extends Sprite
	{
		private var _dataConfig:FZip;
		
		private var _configObj:Object;
		
		private var _GAME_LOADING:Class;
		
		private var _loading:*;
		
		/**
		 * 主文件
		 */
		private var login:Loader;
		public function Main()
		{
//			Security.allowDomain("*");
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}
		
		/**
		 * 初始化
		 */
		private function onAddedToStage(e:Event):void
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu=false;
			
			onStageResize();
			initTouchStage();
			stage.addEventListener(Event.RESIZE,onResize);
			
			
		}
		
		private function initTouchStage():void{
			MultTouchManager.current.init(stage);
			
			var _tuioModule:TuioModule = new TuioModule();
			MultTouchManager.current.addModule(_tuioModule);
			_tuioModule.setHost();
		}
		
		
		private function onResize(e:Event):void
		{
			onStageResize();
		}
		
		public function get loading():*
		{
			return _loading;
		}
		
		public function set loading(value:*):void
		{
			_loading = value;
		}
		/**
		 * socket连接
		 */
		private var socket:BaseSocket;
		
		/**
		 * 开始socket连接
		 */
		public function SocketCon():void
		{
			socket=EPSocket.me;
			socket.initSocket("192.168.1.219", 8012, new WriteBuffer());
			socket.addEventListener(SocketEvent.CONNECTED, onSocketConnected);
			socket.addEventListener(SocketEvent.IOERROR, onSocketIOError);
			socket.addEventListener(SocketEvent.CLOSE,onSocketIOError);
			socket.socketCon();
			loading["loadtxt"].text="start connect " + configObj.serverHost + ":" + configObj.serverPort;
		}
		
		private var dic:Dictionary;
		
		private function onSocketConnected(e:SocketEvent):void
		{
			loading["loadtxt"].text="connected " + configObj.serverHost + ":" + configObj.serverPort;
			// 腾讯接入网关
//			var http_head:String="tgw_l7_forward\r\nHost:" + configObj.serverHost + ":" + configObj.serverPort + "\r\n\r\n";
//			var bytes:ByteArray=new ByteArray();
//			bytes.writeMultiByte(http_head, "UTF-8");
//			socket.sendBytes(bytes);
			
			// 开始加载主文件(包括部分资源文件)
			
//			dic=new Dictionary();
//			dic.Time=configObj.timeStamp.toString();
//			dic.Name=configObj.userName;
//			dic.Param=configObj.parameters;
//			dic.Sign=configObj.sign;
//			dic.ServerId=configObj.serverId;
//			dic.ServerUid=configObj.serverUid;
//			dic.ServerGid=configObj.serverGid;
//			dic.ServerSid=configObj.serverSid;
			
//			socket.sendData(LoginAction.LOGIN, [dic]);
//			loading["loadtxt"].text="sendLogin ";
			
			createUI();
		}
		
		private function onSocketIOError(e:SocketEvent):void
		{
			return;
			loading["loadtxt"].text=e.data;
		}

		
		private var bg:BgWin;
		public function createUI():void
		{
			if(loading.parent){
				(loading.parent as Sprite).removeChild(loading);
 			}
			
			bg = new BgWin();
			this.addChild(bg);
			
			onStageResize();
			
			LayerManager.me.setup(bg);
			
			var dialogdata:DialogData = new DialogData();
			dialogdata.className = MainScreen;
			ViewManager.me.setView(dialogdata);
//			var headView:HeadView=new HeadView();
//			LayerManager.me.bottomSpriteAdd(headView);
		}
		
		public function get configObj():Object
		{
			return _configObj;
		}
		
		/**
		 * 页面配置数据
		 */
		public function set configObj(value:Object):void
		{
			Global.configObj =_configObj=value;
			FilePath.URL=_configObj.swfPath;
			Global.RESOURCE_PATH=_configObj.swfPath;
		}
		
		
		public function get GAME_LOADING():Class
		{
			return _GAME_LOADING;
		}
		
		/**
		 * 加载图标
		 */
		public function set GAME_LOADING(value:Class):void
		{
			_GAME_LOADING=value;
//			GameGlobal.GAME_LOADING=value;
		}
		
		public function onStageResize(evt:Event = null):void
		{
			var w:int=stage.stageWidth;
			var h:int=stage.stageHeight;
			if(bg){
//				if(w > bg.width)
//					bg.x = (w - bg.width)/2;
//				else
//					bg.x = 0;
//				if(h > bg.height)
//					bg.y = (h - bg.height)/2;
//				else
//					bg.y = 0;
				
				bg.scaleX = w/bg.width;
				bg.scaleY = h/bg.height;
			}
			w=w > Global.W ? Global.W : w;
			h=h > Global.H ? Global.H : h;
			
			LayerManager.updateViewRect(w, h);
			LayerManager.me.onSize();
		}
	}
}