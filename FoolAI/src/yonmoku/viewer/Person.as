package yonmoku.viewer {
	import flash.display.BitmapData;
	import yonmoku.Brain;
	public class Person {
		public var name:String;
		public var face:BitmapData;
		public var brain:Brain;
		
		function Person( name:String, face:BitmapData, brain:Brain ) {
			this.name = name; this.face = face; this.brain = brain;
		}
	}
}