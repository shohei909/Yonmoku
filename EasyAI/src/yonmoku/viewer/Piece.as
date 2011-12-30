package yonmoku.viewer {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import yonmoku.*;
	
	/**
	 * 駒のクラス
	 */
	public class Piece extends Bitmap {
		public static const SIZE:int = 22;
		public static const SCALE:int = 2;
		public static const SIZE2:int = SIZE * SCALE;
		/** 盤面上のx座標 */
		public var cx:int;
		/** 盤面上のy座標 */
		public var cy:int;
		
		function Piece( bitmapData:BitmapData, cx:int, cy:int ) {
			super( bitmapData );
			move(cx,cy)
		}
		
		public function move(cx:int, cy:int):void {
			this.cx = cx; this.cy = cy;
			this.scaleX = this.scaleY = SCALE;
			this.x = cx * (SIZE2 + Field.INTERVAL) + Field.INTERVAL;
			this.y = (Yonmoku.HEIGHT - cy - 1) * (SIZE2 + Field.INTERVAL) + Field.INTERVAL;
		}
	}
}