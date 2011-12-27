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
		
		/** 結果表示用ビットマップ */
		public var finMap:BitmapData;
		
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
			
			addChild( new Bitmap( finMap = new BitmapData( w, h, true, 0 ) ) )
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
		
		/** 終了処理。揃った駒を強調 */
		public function finish():void {
			var b:BitmapData = finMap;
			b.lock();
			
			var line:Vector.< Boolean >;
			var turn:Boolean, peace:Boolean;
			var connect:int = 0, x:int = 0, y:int = 0, i:int = 0, h:int = 0, w:int = 0;
			var source:Yonmoku = viewer.source;
			var board:Vector.<Vector.<Boolean>> = source.board;
			
			//縦方向の判定
			for ( x = 0; x < Yonmoku.WIDTH; x++ ) {
				line = board[x];
				var l:int = line.length;
				if ( h < l ) { h = l; }
				if ( l < Yonmoku.CONNECT ) { continue; }
				connect = 0;			
				for ( y = 0; y < l; y++ ) {
					peace = line[y];
					if ( connect == 0 || turn != peace ) {
						turn = peace; connect = 1;
					}else{
						connect++;
						if ( connect >= Yonmoku.CONNECT ) { mark( x, y, 0, 1 ); }
					}
				}
			}
			
			//横方向の判定
			for ( y = 0; y < h; y++ ) {
				var count:int = 0;
				var max:int = 0
				connect = 0;
				for ( x = 0; x < Yonmoku.WIDTH; x++ ){
					line = board[x];
					if ( line.length <= y ) { 
						if( count > max ){ max = count }
						count = 0;
						connect = 0;
						if ( x + Yonmoku.CONNECT < Yonmoku.WIDTH ) { continue; }
						else { break; }
					}
					peace = line[y];
					count++;
					if ( connect == 0 || turn != peace ) {
						turn = peace; connect = 1;
					}else{
						connect++;
						if ( connect >= Yonmoku.CONNECT ) { mark( x, y, 1, 0 ); }
					}
				}
				if ( count > max ) { max = count; }
				if ( y == 0 ){ w = max; }
				if ( max < Yonmoku.CONNECT ) { break; }
			}
			
			if ( h < Yonmoku.CONNECT || w < Yonmoku.CONNECT ) { return; }
			var hh:int = h - connect, ww:int = w - connect, k:int, xx:int;
			
			//ななめ方向の判定
			for ( k = -1; k < 2; k += 2 ) {
				xx = (k < 0) ? (Yonmoku.WIDTH - 1) : 0;
				for ( i = 1; i < hh; i++ ) {
					connect = 0;
					for ( x = xx, y = i; y < h; y++, x += k ) {
						line = board[x];
						if ( line.length <= y ) {
							connect = 0;
							if ( y < hh ) { continue; }
							else { break; }
						}
						peace = line[y];
						if ( connect == 0 || turn != peace ) {
							turn = peace; connect = 1;
						}else{
							connect++;
							if ( connect >= Yonmoku.CONNECT ) { mark( x, y, k, 1 ); }
						}
					}
				}
			}
			for ( k = -1; k < 2; k += 2 ) {
				xx = (k < 0) ? (Yonmoku.WIDTH - 1) : 0;
				for ( i = Yonmoku.HEIGHT; i >= Yonmoku.CONNECT; i-- ) {
					connect = 0;
					for ( x = xx, y = i - 1; y >= 0; y--, x += k ) {
						line = board[x];
						if ( line.length <= y ) {
							connect = 0;
							if ( y < Yonmoku.CONNECT ) { break; }
							else { continue; }
						}
						peace = line[y];
						if ( connect == 0 || turn != peace ) {
							turn = peace; connect = 1;
						}else{
							connect++;
							if ( connect >= Yonmoku.CONNECT ) { mark( x, y, k, -1 ); }
						}
					}
				}
			}
			b.unlock();
		}
		private function mark( x:int, y:int, vx:int, vy:int ):void {
			var b:BitmapData = finMap;
			var s:int = (INTERVAL + Piece.SIZE2);
			x -= (Yonmoku.CONNECT - 1) * vx;
			y -= (Yonmoku.CONNECT - 1) * vy;
			for ( var i:int = 0; i < Yonmoku.CONNECT; i++, x += vx, y += vy ){
				b.fillRect( new Rectangle( s * x, s * (Yonmoku.HEIGHT - y - 1), s, s ), 0x88FF6600 );
			}
		}
		
		
		/** 再開処理。 */
		public function restart():void {
			var b:BitmapData = finMap;
			b.fillRect( b.rect, 0 );
		}
		
	}
}