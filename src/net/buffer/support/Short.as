package net.buffer.support
{
	public class Short
	{
		private var _value:int;
		public function Short(_value:int)
		{
			this._value=_value;
		}
		
		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			_value = value;
		}

	}
}