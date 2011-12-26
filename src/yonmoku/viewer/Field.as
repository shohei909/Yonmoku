package yonmoku.viewer {
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import yonmoku.*;
	import yonmoku.brain.Human;
	
	/**
	 * 盤面の表示スプライト
	 */
	public class Field extends Sprite {
		/** 駒　*/
		public var map:Vector.< Vector.<Piece> >;
		/** 駒ごとの隙間 */
		public static const INTERVAL:int = 1;
		
		/** 親になるビューア */
		public var viewer:Viewer;
		
		/** ヒント用ビットマップ　*/
		public var hintMap:BitmapData;
		public var hintPiece:Piece;
		
		function Field( viewer:Viewer ) {
			this.viewer = viewer;
			
			var w:int = INTERVAL * (Yonmoku.WIDTH + 1) + Piece.SIZE2 * Yonmoku.WIDTH;
			var h:int = INTERVAL * (Yonmoku.HEIGHT + 1) + Piece.SIZE2 * Yonmoku.HEIGHT;
			var span:int = INTERVAL + Piece.SIZE2;
			
			var back:Shape = new Shape;
			var g:Graphics = back.graphics;
			g.beginBitmapFill( Data.image["back"]["field"] );
			g.drawRect( 1, 1, w-1, h-1 );
			addChild( back );
			
			//グリッド作成
			var grid:BitmapData = new BitmapData( w, h, true, 0 );
			grid.lock();
			for (var i:int = 0; i < Yonmoku.HEIGHT + 1; i++ ) {
				grid.fillRect( new Rectangle( 0, i * span, w, INTERVAL ), 0xFFDDDDEE );	//横線
			}for ( i = 0; i < Yonmoku.WIDTH + 1; i++ ) {
				grid.fillRect( new Rectangle( i * span, 0, INTERVAL, h ), 0xFFDDDDEE ); //縦線
			}
			grid.unlock();
			
			addChild( new Bitmap( hintMap = new BitmapData( w, h, true, 0 ) ) )
			addChild( hintPiece = new Piece( viewer.pieces[0], 0, 0 ) );
			hintPiece.alpha = 0.2;
			hintPiece.visible = false;
			addChild( new Bitmap( grid ) );
			
			map = new Vector.< Vector.<Piece> >( Yonmoku.WIDTH, true );
			for ( i = 0; i < Yonmoku.WIDTH; i++ ) {
				map[i] = new Vector.<Piece>();
			}
			update();
		}
		
		/** 盤面を更新 */
		public function update():void {
			var a:Array = [];
			var source:Yonmoku = viewer.source;
			
			//変更を調べて更新
			for ( var i:int = 0; i < Yonmoku.WIDTH; i++ ) {
				var line:Vector.<Piece> = map[i];
				var l1:int = line.length;
				var l2:int =source.board[i].length;
				var piece:Piece;
				if( l1 <= l2 ){
					for ( ; l1 < l2; l1++ ) {
						var t:Boolean = source.board[i][l1];
						piece = new Piece( viewer.pieces[int(t)], i, l1 )
						line.push( piece );
						addChild( piece );
					}
				}else {
					for ( ; l2 < l1; l2++ ) {
						piece = line.pop();
						removeChild( piece );
					}
				}
			}
			hintPiece.bitmapData = viewer.pieces[int(source.turn)];
			hint( false );
		}
		
		/** 入力ヒントを表示　*/
		public function hint( display:Boolean ):void {
			var b:BitmapData = hintMap;
			b.fillRect( b.rect, 0x00000000 );
			hintPiece.visible = false;
			if (! display ) { return; }
			
			var mx:int = int( mouseX * Yonmoku.WIDTH / b.width );
			var my:int = mouseY;
			
			if ( 0 < my && my < b.height && 0 <= mx && mx < Yonmoku.WIDTH ) {
				var l:int = map[mx].length;
				if ( l == Yonmoku.HEIGHT ) { return; }
				var w:int = (INTERVAL + Piece.SIZE2);
				b.fillRect( new Rectangle( w * mx, 0, w, b.height ), 0x55FF9999 );
				hintPiece.visible = true;
				hintPiece.move( mx, l );
			}
		}
		
		/** 動く　*/
		public function move( human:Human ):void {
			var mx:int = int( (mouseX * Yonmoku.WIDTH) / hintMap.width );
			if ( 0 <= mx && mx < Yonmoku.WIDTH ) {
				var l:int = map[mx].length;
				if ( l == Yonmoku.HEIGHT ) { return; }
				human.move( new Move( mx ) );
			}
		}
		
		
	}
}