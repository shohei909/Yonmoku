package yonmoku.viewer {
	import flash.display.Sprite;
	import flash.text.engine.*;
	public class Text extends Sprite {
		
		public var size:int;
		public var color:uint;
		public var align:String;
		public function Text( text:String, size:int = 10, color:uint = 0, align:String = "left" ){
			this.size = size;
			this.color = color;
			this.align = align;
			setText( text );
		}
		
		public function setText( text:String ):void {
			if ( numChildren > 0 ) { removeChildAt(0); }
			if ( text == "" ) { return; }
			var t:TextLine;
			addChild( 
				t = new TextBlock(
					new TextElement(
						text,
						new ElementFormat(
							new FontDescription( "_sans" ),
							size, color, 1, "auto", "roman", "useDominantBaseline", 0, "on", 0, 0, "ja"
						)
					)
				).createTextLine()
			);
			switch( align ){
				case "center":
					t.x = -t.width / 2; break;
				case "right":
					t.x = -t.width; break;
			}
		}
	}
}