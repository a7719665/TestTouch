package com.data
{
	public class DialogData
	{
		public function DialogData()
		{
		}
		private var _winName:String;
		
		private var _winData:Object;
		
		private var _className:Class;
		
		private var _x:int;
		
		private var _y:int;

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		/**
		 * 打开窗口时传的数据
		 * */
		public function get winData():Object
		{
			return _winData;
		}

		public function set winData(value:Object):void
		{
			_winData = value;
		}

		/**
		 * 窗口名，必须与bottom条里面的按钮名一模一样
		 * */
		public function get winName():String
		{
			return _winName;
		}

		public function set winName(value:String):void
		{
			_winName = value;
		}

		/**
		 * 窗口的类名用于反射创建
		 * */
		public function get className():Class
		{
			return _className;
		}

		public function set className(value:Class):void
		{
			_className = value;
		}
		
		

	}
}