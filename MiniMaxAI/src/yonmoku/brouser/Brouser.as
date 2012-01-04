package yonmoku.brouser {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	/**
	 * redoやundoが簡単にできるPage閲覧クラス
	 */
	public class Brouser extends Sprite {
		public var log:Vector.<Page> = new Vector.<Page>;	//ページのログ
		private var p:int = -1;								//現在表示しているページ数
		public var page:Page;								//現在表示しているページ
		
		public function Brouser() {}
		
		public function open( page:Page ):void {
			if ( this.page ) { this.page.close(); }
			
			this.page = page;
			page.open( this );
			log.splice( ++p, uint.MAX_VALUE );
			log.push( page );
		}
		
		public function undo():void {
			if ( p < 1 ) { return; }
			page.close();
			page = log[--p];
			page.open( this );
		}
		
		public function redo():void {
			if ( p < 1 ) { return; }
			page.close();
			page = log[--p];
			page.open( this );
		}
		
		//アラート
		private var alertWindow:DisplayObject;
		
		/** dを最前面に表示する */
		public function alert( d:DisplayObject ):void {
			this.filters = [ new BlurFilter(8, 8, 2), new ColorMatrixFilter([0.5,0.2,0.2,0,24,0.2,0.5,0.2,0,24,0.2,0.2,0.5,0,69,0,0,0,1,0]) ];
			this.mouseChildren = false;
			stage.addChild( alertWindow = d );
		}
		
		/**　alertを閉じる */
		public function close():void {
			if (! alertWindow ) { return; }
			stage.removeChild( alertWindow );
			this.filters = [];
			this.mouseChildren = true;
			alertWindow = null;
		}
	}
}