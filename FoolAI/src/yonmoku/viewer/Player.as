package yonmoku.viewer {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import yonmoku.Brain;
	import yonmoku.*;
	
	public class Player extends Sprite {
		public static var glow:GlowFilter = new GlowFilter( 0xFF8800 );
		public var face:Bitmap;
		public var line:Bitmap;
		public var piece:Bitmap;
		public var turn:Boolean;
		
		public function Player( viewer:Viewer, turn:Boolean ) {
			this.turn = turn;
			var p:Person = viewer.people[ int(turn) ]
			var man:BitmapData = p.face;
			var b:BitmapData;
			
			addChild( line = new Bitmap( new BitmapData( 1,1, false, 0 ) ) );
			addChild( face = new Bitmap( b = new BitmapData( man.width, man.height, false, [0xFFAAAA, 0xAAAAFF][int(turn)] ) ) );
			addChild( piece = new Bitmap( viewer.pieces[ int(turn) ] ) );
			
			
			face.scaleX = face.scaleY = 2;
			face.x = face.y = 2;
			line.scaleX = (face.height + 4);
			line.scaleY = (face.width + 4);
			
			var text:Text;
			addChild( text = new Text(turn ? "あと"　: "さき") );
			
			piece.y = line.height + 4;
			text.y = piece.y + (piece.height + text.height)/ 2;
			text.x = (piece.width - text.width  + line.width) / 2;
			
			addChild( text = new Text(p.name) );
			text.y = -2;
			
			b.draw( man );
		}
		
		public function draw( select:Boolean ):void {
			line.filters = select?[glow]:[];
			var b:BitmapData = line.bitmapData;
			b.fillRect( b.rect, select ? 0xFF0000:0 );
		}
	}
}