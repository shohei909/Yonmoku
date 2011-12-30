package yonmoku{
	/**  四目並べのクラス。機能は必要最低限でまとめる。 */
	public class Yonmoku implements Game {
		public static const WIDTH:int = 6;		//盤の幅
		public static const HEIGHT:int = 6;		//盤の高さ
		public static const CONNECT:int = 4;	//四つ並べたら勝ち
		public static const PASS_COUNT:int = 2;	//パスが可能になるまでの手数。
		
		public var brains:Vector.<Brain>;		//二人の頭脳。
		public var board:Vector.<Vector.<Boolean>>;	//盤面。falseが先手の駒、trueが後手の駒。
		
		public var finished:Boolean;			//ゲームが終了しているか？
		public var winner:int; 					//勝者。1が先手勝ち,2が後手勝ち,0が引き分け
		
		public var passCount:int = 1;			//0になればパス可。
		
		public var turn:Boolean;				//現在の手番。falseが先手、trueが後手。
		
		public var last:Move;					//直前の着手。
		
		public var wait:Boolean;				//プレーヤー着手を待機しているかどうか?
		
		
		/** コンストラクタ */
		function Yonmoku( b1:Brain, b2:Brain ) {
			b1.target = b2.target = this;
			brains = Vector.<Brain>( [ b1, b2 ] );
			board = new Vector.<Vector.<Boolean>>( WIDTH, true );
			for ( var i:int = 0; i < WIDTH; i++ ) {
				board[i] = new Vector.<Boolean>();
			}
		}
		
		
		/** 評価関数、現在のプレーヤーについて計算 */
		public function evaluate( ...args ):Number { 
			//あとで書くよ！
			return 0; 
		}
		
		
		/** 着手 */
		public function move( m:Move ):void {
			wait = false;
			m.prev = last;
			last = m;
			
			var value:int = m.value as int;
			if ( value >= 0 ) { 
				board[ value ].push( turn ); 
				if ( passCount > 0 ) { passCount--; }
			}else {
				passCount = PASS_COUNT;
			}
			turn = !turn;
			_check();
		}
		
		
		/** 勝負を進める。　*/
		public function progress():void {
			if ( finished || wait ) { return; }
			var p:Vector.<Move> = movable();
			wait = true;
			brains[ int(turn) ].think( p ); //brainに着手を申請。
		}
		
		
		/** 着手候補を挙げる　*/
		public function movable():Vector.<Move> {
			if ( _movables && (log == last) ) { return _movables; }
			log = last;
			var ms:Vector.<Move> = new Vector.<Move>;
			if ( passCount == 0 ) ms.push( new Move( -1 ) );
			for ( var i:int = 0; i < WIDTH; i++ ) {
				if ( board[i].length != HEIGHT ) { ms.push( new Move( i ) ); }
			}
			return (_movables = ms);
		}
		private var _movables:Vector.<Move>;	//着手候補のログ
		private var log:Move;					//最後にログを取った位置
		
		
		/** 終局を判定 */
		private function _check():void {
			
			var line:Vector.< Boolean >;
			var turn:Boolean, piece:Boolean;
			var connect:int = 0, x:int = 0, y:int = 0, i:int = 0, h:int = 0, w:int = 0;
			
			//縦方向の判定
			for ( x = 0; x < WIDTH; x++ ) {
				line = board[x];
				var l:int = line.length;
				if ( h < l ) { h = l; }
				if ( l < CONNECT ) { continue; }
				connect = 0;			
				for ( y = 0; y < l; y++ ) {
					piece = line[y];
					if ( connect == 0 || turn != piece ) {
						turn = piece; connect = 1;
					}else{
						connect++;
						if ( connect == CONNECT ) { finished = true; winner = turn + 1; return; }
					}
				}
			}
			
			//横方向の判定
			for ( y = 0; y < h; y++ ) {
				var count:int = 0;
				var max:int = 0
				connect = 0;
				for ( x = 0; x < WIDTH; x++ ){
					line = board[x];
					if ( line.length <= y ) { 
						if( count > max ){ max = count }
						count = 0;
						connect = 0;
						if ( x + CONNECT < WIDTH ) { continue; }
						else { break; }
					}
					piece = line[y];
					count++;
					if ( connect == 0 || turn != piece ) {
						turn = piece; connect = 1;
					}else{
						connect++;
						if ( connect == CONNECT ) { finished = true; winner = turn + 1; return; }
					}
				}
				if ( count > max ) { max = count; }
				if ( y == 0 ){ w = max; }
				if ( max < CONNECT ) { break; }
			}
			
			if ( h < CONNECT || w < CONNECT ) { return; }
			var hh:int = h - connect, ww:int = w - connect, k:int, xx:int;
			
			//ななめ方向の判定
			for ( k = -1; k < 2; k += 2 ) {
				xx = (k < 0) ? (WIDTH - 1) : 0;
				for ( i = 1; i < hh; i++ ) {
					connect = 0;
					for ( x = xx, y = i; y < h; y++, x += k ) {
						line = board[x];
						if ( line.length <= y ) {
							connect = 0;
							if ( y < hh ) { continue; }
							else { break; }
						}
						piece = line[y];
						if ( connect == 0 || turn != piece ) {
							turn = piece; connect = 1;
						}else{
							connect++;
							if ( connect == CONNECT ) { finished = true; winner = turn + 1; return; }
						}
					}
				}
			}
			for ( k = -1; k < 2; k += 2 ) {
				xx = (k < 0) ? (WIDTH - 1) : 0;
				for ( i = HEIGHT; i >= CONNECT; i-- ) {
					connect = 0;
					for ( x = xx, y = i - 1; y >= 0; y--, x += k ) {
						line = board[x];
						if ( line.length <= y ) {
							connect = 0;
							if ( y < CONNECT ) { break; }
							else { continue; }
						}
						piece = line[y];
						if ( connect == 0 || turn != piece ) {
							turn = piece; connect = 1;
						}else{
							connect++;
							if ( connect == CONNECT ) { finished = true; winner = turn + 1; return; }
						}
					}
				}
			}
			
			//引き分けの判定
			var p:Vector.<Move> = movable();
			if ( p.length == int( passCount == 0 ) ) {
				finished = true;
				winner = 0;
				return;
			}
		}
		
		/** 1手戻る　*/
		public function back():void {
			if (! last ) { return; }
			brains[ int(turn) ].stop();
			
			var m:Move = last;
			if( m.value >= 0 ) board[ m.value ].pop();
			m = last = m.prev;
			
			for ( var p:int = PASS_COUNT; p > 0; p-- ) {
				if (! m ) { p--; break; }
				if ( m.value == -1 ) { break; }
				m = m.prev;
			}
			passCount = p;
			
			
			turn = !turn;
			wait = false;
			finished = false;
		}
	}
}