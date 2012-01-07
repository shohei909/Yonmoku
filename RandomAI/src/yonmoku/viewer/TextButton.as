package yonmoku.viewer {
	import flash.filters.GlowFilter;
	public class TextButton extends Button{
		public static const shadow:GlowFilter = new GlowFilter( 0xFF2200, 1, 4, 4, 255 );
		public var label:Text;
		public function TextButton( text:String, onClick:Function = null, size:int = 11, align:String = "left" ):void{
			super( onClick );
			addChild( label = new Text(text, size, 0xFFFFFF, align ) );
			label.filters = [shadow];
		}
	}
}