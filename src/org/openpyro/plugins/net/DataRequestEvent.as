package org.openpyro.plugins.net
{
	import flash.events.Event;

	public class DataRequestEvent extends Event
	{
		public static var SUCCESS:String = "success";
		public static var FAILURE:String = "failure";
		
		public function DataRequestEvent(type:String)
		{
			super(type);
		}
		
		private var _failureKind:String;
		public function set failureKind(kind:String):void{
			_failureKind = kind;
		}
		
		public function get failureKind():String{
			return _failureKind;
		}
		
		private var _data:Object
		public function set data(value:Object):void{
			_data = value
		}
		public function get data():Object{
			return _data;
		}
	}
}