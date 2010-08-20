package org.openpyro.flint.utils{
	import org.openPyro.utils.ArrayUtil;
	
	public class Version{
		
		private var _version:String;
		private var _data:*;
	
		public function Version(version:String, data:* = null){
			this._version = version;
			this._data = data;
		}
		
		public function get version():String{
			return _version;
		}
		
		public function get data():*{
			return _data;
		}
		
		public static function selectLatest(latestVersion:Version, localVersion:Version, betaVersion:Version=null):Version{
			
			var latestMainVersion:String = latestVersion.version;
			if(latestVersion.version.indexOf("-beta") != -1){
				throw Error("Latest version should not be a beta version")
			}
			
			var localMainVersion:String = localVersion.version.split("-beta")[0];
			var localBetaRevisionNumber:String =  localVersion.version.split("-beta")[1];;
			
			var latestBetaMainVersion:String;
			var latestBetaRevisionNumber:String;
			
			if(betaVersion){
				latestBetaMainVersion = betaVersion.version.split("-beta")[0];
				latestBetaRevisionNumber =  betaVersion.version.split("-beta")[1];;	
			}
			
			if(!betaVersion){
				if(isVersionGreater(latestMainVersion, localMainVersion) == 1){
					return latestVersion;
				}
				else{
					return localVersion;
				}
			}
			else{
				
				var compare:int;
				
				if(isVersionGreater(latestBetaMainVersion, latestMainVersion) == 1){
					// check against the beta version
					compare = isVersionGreater(localMainVersion, latestBetaMainVersion);
					switch(compare){
						case -1:	return betaVersion;
									break;
						case 0: 	if(localBetaRevisionNumber < latestBetaRevisionNumber){
										return betaVersion;	
									}
									break;
						case -1:   	return localVersion;
									break
						
					}	
				}
				else{
					if(isVersionGreater(latestMainVersion, localMainVersion) == 1){
						return latestVersion;
					}
					else{
						return localVersion;
					}
				}
			}
			// if null, there was some error in my logic
			return null;
		}
		
		/**
		 * Returns:
		 * 
		 * 1 if v1 > v2;
		 * 0 if v1 = v2;
		 * -1 if v1 < v2;
		 */ 
		public static function isVersionGreater(version1:String, version2:String):int{
			var origArray:Array = version1.split(".");
			var version2Array:Array = version2.split(".");
			ArrayUtil.pad(origArray, Math.max(origArray.length, version2Array.length));
			ArrayUtil.pad(version2Array,Math.max(origArray.length, version2Array.length));
			
			for(var i:int=0; i<origArray.length; i++){
				if(version2Array[i] > origArray[i]){
					return -1;
				}
				if(version2Array[i] < origArray[i]){
					return 1;
				}
			}
			return 0;
		}
	}
}