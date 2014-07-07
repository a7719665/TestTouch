package net.buffer.support
{
	/**
	 * 长整形,区分Number,长度只支持Number
	 */
	public class Long
	{
		private var _value:Number;
		public function Long(_value:Number)
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