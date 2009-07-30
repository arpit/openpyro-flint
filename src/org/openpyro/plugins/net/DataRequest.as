package org.openpyro.plugins.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * The DataRequest class is a convinience class that abstracts out the 
	 * details of making an HTTP request to a remote URL
	 */ 
	public class DataRequest extends EventDispatcher
	{
		private var _urlLoader:URLLoader;
		private var _variables:URLVariables;
		private var _url:String;
		
		/**
		 * Constructor
		 */ 
		public function DataRequest(url:String=null)
		{
			_url = url;
			initLoader();
		}
		
		private var _urlRequest:URLRequest;
		
		/**
		 * The DataRequest class can create its own URLRequest object
		 * but if a custom URLRequest object needs to be created, that 
		 * can be set and the class will use that to make the remote 
		 * calls.
		 */
		public function get urlRequest():URLRequest
		{
			return _urlRequest;
		}

		/**
		 * @private
		 */
		public function set urlRequest(v:URLRequest):void
		{
			_urlRequest = v;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(v:String):void
		{
			_url = v;
		}

		private function initLoader():void
		{
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
		}
		
		/**
		 * Sets all the <code>URLVariables</code> values based
		 * on the object passed in.
		 * 
		 * Example:
		 * var params:Object = {prop1:"val1", prop2:"val2"};
		 * var dataRequest:DataRequest = new DataRequest();
		 * dataRequest.setVars(params);
		 */ 
		public function setParams(varsObject:Object):void
		{
			if(!_variables){
				_variables = new URLVariables();
			}
			for(var a:String in varsObject){
				_variables[a] = varsObject[a];
			}
		}
		
		
		public function addParam(param:String, value:String):void{
			if(!_variables){
				_variables = new URLVariables();
			}
			_variables[param] = value;
		}
		
		private var _requestHeaders:Array = null;
		
		public function addRequestHeader(name:String, value:String):void{
			var header:URLRequestHeader = new URLRequestHeader(name, value);
			if(!_requestHeaders){
				_requestHeaders = new Array();
			}
			_requestHeaders.push(header);
		}
		
		/**
		 * Makes an HTTP GET request with the URL variables set in the <code>addParam</code> or 
		 * <code>setParams</code> method and the request headers set in the 
		 * <code>addRequestHeader</code> method.
		 */ 
		public function get():void{
			if(!_urlRequest){
				var _urlRequest:URLRequest = new URLRequest(_url);
				_urlRequest.data = _variables;
			}
			if(_requestHeaders != null){
				_urlRequest.requestHeaders = _requestHeaders;
			}
			_urlRequest.method = URLRequestMethod.GET;
			_urlLoader.load(_urlRequest);
		}
		
		/**
		 * Makes an HTTP POST request with the URL variables set in the <code>addParam</code> or 
		 * <code>setParams</code> method and the request headers set in the 
		 * <code>addRequestHeader</code> method.
		 */ 
		public function post():void
		{
			if(!_urlRequest){
				var _urlRequest:URLRequest = new URLRequest(_url);
				_urlRequest.data = _variables;
			}
			if(_requestHeaders != null){
				_urlRequest.requestHeaders = _requestHeaders;
			}
			_urlRequest.method = URLRequestMethod.POST;
			_urlLoader.load(_urlRequest);	
		}
		
		private function onLoadComplete(event:Event):void
		{
			var successEvent:DataRequestEvent = new DataRequestEvent(DataRequestEvent.SUCCESS);
			successEvent.data = _urlLoader.data;
			dispatchEvent(successEvent);
		}
		
		private function onErrorEvent(event:Event):void
		{
			var failEvent:DataRequestEvent = new DataRequestEvent(DataRequestEvent.FAILURE);
			failEvent.failureKind = event.type;
			dispatchEvent(failEvent);
			
		}
		
	}
}