package yonmoku.brouser {
	import flash.display.Sprite;
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
	}
}