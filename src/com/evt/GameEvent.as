package com.evt
{
	import flash.events.Event;

	public class GameEvent extends Event
	{		
		public static const LOGIN_BACK:String="login_back";
		/**
		 * 打开npc对话面板
		 */
		public static const OPEN_NPC_TALK:String="open_npc_talk";
		/**
		 * 事件数据
		 */
		private var _data:Object;
		
				
		public function GameEvent(type:String,data:Object=null,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			this.data=data;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}