package yonmoku.brouser {
	import flash.display.Sprite;
	/**
	 * ページ。Brouserクラスを使って閲覧する。
	 */
	public class Page extends Sprite{
		public var brouser:Brouser;
		
		/** brouserを使ってこのページを表示 */
		public function open( brouser:Brouser ):void {
			if ( brouser ) { close(); }
			this.brouser = brouser;
			brouser.addChild( this ); 
		}
		
		/** このページから離れる。 */
		public function close():void {
			if (! brouser ) { return; }
			brouser.removeChild( this );
			brouser = null;
		}
	}
}