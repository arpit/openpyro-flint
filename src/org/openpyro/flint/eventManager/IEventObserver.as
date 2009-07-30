package org.openpyro.flint.eventManager
{
	public interface IEventObserver
	{
		function onEvent(event:ManagedEvent):void;
	}
}