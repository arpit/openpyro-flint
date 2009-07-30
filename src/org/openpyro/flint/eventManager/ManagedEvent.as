package org.openpyro.flint.eventManager
{
	import flash.events.Event;

	public class ManagedEvent extends Event
	{
		public static const MANAGED_EVENT:String = "managedEvent";
		
		private var _eventType:String;
		public function ManagedEvent(eventType:String)
		{
			_eventType = eventType;
			super(MANAGED_EVENT);
		}
		
		public function get eventType():String{
			return _eventType;
		}
	}
}