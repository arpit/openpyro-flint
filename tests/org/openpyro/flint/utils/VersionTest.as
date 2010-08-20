package org.openpyro.flint.utils
{
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertTrue;
	
	public class VersionTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testIsVersionGreater():void
		{
			assertTrue(Version.isVersionGreater("0.0.1","0.0.2") == -1);
		}
		
		[Test]
		public function testSelectLatest():void
		{
			var v1:Version = new Version("0.0.1");
			var v2:Version = new Version("0.0.2");
			var v3:Version = new Version("0.0.1-beta1");
			var v4:Version = new Version("0.0.1-beta2");
			
			var v5:Version = new Version("0.1.0");
			
			var selected:Version 
			
			
			selected = Version.selectLatest(v2, v1);
			assertTrue(selected == v2);
			
			selected = Version.selectLatest(v2, v1);
			assertTrue(selected == v2);
			
			selected = Version.selectLatest(v1, v3);
			assertTrue(selected == v3);
			
			selected = Version.selectLatest(v2, v1, v3);
			assertTrue(selected == v2);
			
			selected = Version.selectLatest(v5, v1);
			assertTrue(selected == v5);
			
			selected = Version.selectLatest(v5, v1, v4);
			assertTrue(selected == v5);
		
			selected = Version.selectLatest(v5, v1, null);
			assertTrue(selected == v5);
			
			var vx:Version = new Version("0.7.3-beta1");
			var vz:Version = new Version("0.7.0");
			var vy:Version = new Version("0.7.3-beta1")
			selected = Version.selectLatest(vz, vx ,vy);
			assertTrue(selected == vx);
		
			
		}
	}
}