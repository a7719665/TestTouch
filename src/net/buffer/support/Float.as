package net.buffer.support
{
	public class Float
	{
		private var _value:Number;
		public function Float(_value:Number)
		{
			this._value=_value;
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value;
		}

	}
}