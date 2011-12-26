package yonmoku{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	public class Data {
		public static const IMG_FOLDER:String = "img/";
		public static const IMG_FORMAT:String = ".png"
		public static const IMG:Array = [
			["piece", [ "strawberry", "grape", "banana", "orange", "meron" ]],
			["man", [ "nobody" ]],
			["back", [ "field", "stage" ]],
			["move", [ "first","undo","redo","end","new" ]]
		];
		public static var image:Object = {};
		public static var loaders:Vector.<Loader>;
		public static var onLoaded:Function;
		
		public static function load():Vector.<Loader> {
			if( loaders ){ return loaders }
			loaders = new Vector.<Loader>();
			for each( var arr:Array in IMG ) {
				var file:String = arr[0];
				var loader:Loader = new Loader();
				loader.load( new URLRequest(IMG_FOLDER + file + IMG_FORMAT) );
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _onComplete );
				loaders.push( loader );
			}
			return loaders;
		}
		
		private static var compCount:int = 0;
		private static function _onComplete( e:Event ):void {
			compCount++;
			if ( compCount == IMG.length ) { 
				_setupImage();
				if ( onLoaded != null ) { onLoaded(); }
			}
		}
		
		private static function _setupImage():void {
			var mtr:Matrix = new Matrix();
			for (var i:int = 0, l:int = IMG.length; i < l; i++) {
				var img:Array = IMG[i];
				var group:String = img[0];
				var loader:Loader = loaders[i];
				var obj:Object = image[group] = {};
				var arr:Array = img[1];
				var ll:int = arr.length;
				var width:int = loader.width / ll;
				var height:int = loader.height;
				for ( var j:int = 0; j < ll; j++ ) {
					var file:String = arr[j]
					var b:BitmapData = new BitmapData(width, height, true, 0);
					mtr.tx = - j * width;
					b.draw( loader, mtr );
					obj[ file ] = b;
				}
			}
		}
		
	}
}