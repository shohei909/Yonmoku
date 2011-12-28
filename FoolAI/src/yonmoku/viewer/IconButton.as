package yonmoku.viewer {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	public class IconButton extends Button{
		public var bitmap:Bitmap;
		public var text:Text;
		public function IconButton( icon:BitmapData, label:String = "", onClick:Function = null, fontSize:int = 8 ) {
			super( onClick );
			addChild( bitmap = new Bitmap( icon ) );
			addChild( text = new Text( label, fontSize, 0x555555, "center" ) );
			text.y = bitmap.height + text.height;
			text.x = bitmap.width / 2;
		}
	}

}