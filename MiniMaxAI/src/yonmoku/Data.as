package yonmoku{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	public class Data {
		[Embed(source='../asset/back.png')]
        static private var back:Class;
		[Embed(source='../asset/man.png')]
        static private var man:Class;
		[Embed(source='../asset/move.png')]
        static private var move:Class;
		[Embed(source='../asset/piece.png')]
        static private var piece:Class;
		[Embed(source='../asset/head.png')]
        static private var head:Class;
		
		static public const P:Array = [ 0, 2, 16, 128, 10000 ];
		static public const TABLE:Array = [
			P[0], // 0
			P[1], // 1
			P[1], // 10
			P[2], // 11
			P[1], // 100
			P[2], // 101
			P[2], // 110
			P[3], // 111
			P[1], // 1000
			P[2], // 1001
			P[2], // 1010
			P[3], // 1011
			P[2], // 1100
			P[3], // 1101
			P[3], // 1110
			int.MAX_VALUE >> 1, // 勝ち
			P[4]
		];
		
		public static const IMG:Array = [
			["piece", [ "strawberry", "grape", "banana", "orange", "meron" ]],
			["man", [ "nobody" ]],
			["back", [ "field", "stage" ]],
			["move", [ "first","undo","redo","end","new","play","system", "back", "spin" ]],
			["head", [ "fool", "easy", "minimax" ]]
		];
		public static var image:Object = {};
		public static var onLoaded:Function;
		
		public static function setupImage():void {
			var mtr:Matrix = new Matrix;
			for each( var arr:Array in IMG ) {
				var file:String = arr[0];
				
				var c:Class = Data[file];
				var bitmap:Bitmap = new c();
				
				var obj:Object = image[file] = {};
				var a:Array = arr[1];
				var ll:int = a.length;
				var width:int = bitmap.width / ll;
				var height:int = bitmap.height;
				
				for ( var j:int = 0; j < ll; j++ ) {
					var name:String = a[j]
					var b:BitmapData = new BitmapData(width, height, true, 0);
					mtr.tx = - j * width;
					b.draw( bitmap, mtr );
					obj[ name ] = b;
				}
			}
		}
		
	}
}