package org.openpyro.flint.eventManager
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * The EventManager class provides a central Event Bus to allow events
	 * to be passed between different objects without actually referencing
	 * the actual object itself. The EventManager maintains a map of listeners
	 * each implementing the IEventObserver interface. Additionally the listener
	 * can pass it an actual instance of the target if it only wants to listen 
	 * to an event from a specific instance 
	 * 
	 * EventManager.getDefault().addObserver(this, "someEvent");
	 * EventManager.getDefault().registerSource(this);
	 * dispatchEvent(new ManagedEvent("someEvent"));
	 * 
	 */ 
	public class EventManager
	{
		public function EventManager()
		{
			targetMap = new Dictionary();
		}
		
		private static var _defaultEventManager:EventManager;
		
		/**
		 * A static helper method to get a default EventManager object.
		 * EventManager is NOT a Singleton and new instances can be
		 * created if an application wishes, but the static getDefault
		 * method returns one thats always present. 
		 */
		public static function getDefault():EventManager{
			if(!_defaultEventManager){
				_defaultEventManager = new EventManager();
			}
			return _defaultEventManager;
		}
		
		
		private var targetMap:Dictionary;
		
		
		public function addListener(eventType:String, callback:Function, sender:Object=null):void{
			if(targetMap[eventType] == null){
				targetMap[eventType] = [{sender:sender, callback:callback}];
			}
			else{
				targetMap[eventType].push({sender:sender, callback:callback});
			}
		}
		
		/**
		 * Removes an observer for a particular eventType
		 */ 
		public function removeListener(eventType:String, callback:Function):void{
			var observers:Array = targetMap[eventType];
			if(!observers) return;
			var observerIndex:Number = -1;
			for(var i:int=0 ; i<observers.length; i++){
				if(observers[i].callback == callback){
					observerIndex = i;
					break;
				}
			}
			if(observerIndex==-1){
				return;
			}
			observers.splice(observerIndex,1);
		}
		
		public function registerSource(source:EventDispatcher):void{
			source.addEventListener(ManagedEvent.MANAGED_EVENT, onManagedEventDispatched);
		}
		
		private function onManagedEventDispatched(event:ManagedEvent):void{
			if(targetMap[event.eventType] != null){
				var possibleTargets:Array = targetMap[event.eventType];
				for each(var target:Object in possibleTargets){
					if(target.sender == event.currentTarget || target.sender == null){
						target.callback(event)
					}
				}
			}
		}
		
		
	}
}