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
			if ( b1 ) b1.target = this;
			if ( b2 ) b2.target = this;
			if ( b1 || b2 ){ brains = Vector.<Brain>( [ b1, b2 ] ); }
			board = new Vector.<Vector.<Boolean>>( WIDTH, true );
			for ( var i:int = 0; i < WIDTH; i++ ) {
				board[i] = new Vector.<Boolean>();
			}
			last = new Move( null );			//空の着手
			last.game = this;
		}
		
		
		/** 評価関数、現在のプレーヤーについて計算 */
		public function evaluate( table:Array = null ):Number { 
			var n:Number = 0;
			var s:int = 0;
			var line:Vector.< Boolean >;
			var t:Boolean, piece:Boolean;
			var connect:int = 0, space:int = 0, x:int = 0, y:int = 0, i:int = 0, h:int = 0, hMax:int = 0;
			var max:int = 0;
			
			//縦方向の判定
			for ( x = 0; x < WIDTH; x++ ) {
				line = board[x];
				var l:int = line.length;
				if ( l == 0 ) { continue; }
				connect = 0; 
				s = 0;
				for ( y = 0; y < l; y++ ) {
					piece = line[y];
					if ( connect == 0 || t != piece ) {
						t = piece; connect = 1; s = 1;
					}else {
						s = ((s << 1) + 1) & 0xF;
						connect++;
						if ( connect >= CONNECT ) {
							n += ((t == turn) ? 1.5 : -1) * table[s];
						}
					}
				}
				if ( hMax < l ) { hMax = l; }
				h = l + CONNECT - 1;
				if ( h > HEIGHT ) { h = HEIGHT; }
				for (; y < h; y++ ) {
					connect++;
					s = (s << 1) & 0xF;
					if ( connect >= CONNECT ) {
						n += ((t == turn) ? 1.5 : -1) * table[s];
					}
				}
			}
			
			//横方向の判定
			for ( y = 0; y < hMax; y++ ) {
				connect = 0;
				space = 0;
				s = 0;
				for ( x = 0; x < WIDTH; x++ ){
					line = board[x];
					if ( line.length <= y ) {
						connect++;
						space++;
						s = (s << 1) & 0xF;
					}else{
						piece = line[y];
						if ( s == 0 || t != piece ) {
							t = piece; connect = 1 + space; s = 1;
						}else{
							connect++;
							s = ((s << 1) + 1) & 0xF;
						}
						space = 0;
					}
					if ( connect >= CONNECT ) {
						n += ((t == turn) ? 1.5 : -1) * table[s];
					}
				}
			}
			
			var hh:int = hMax - CONNECT + 1, k:int = 0, xx:int = 0;
			
			//ななめ方向の判定
			for ( k = -1; k < 2; k += 2 ) {
				xx = (k < 0) ? (WIDTH - 1) : 0;
				for ( i = 1; i < hh; i++ ) {
					connect = 0;
					space = 0;
					s = 0;
					for ( x = xx, y = i; y < HEIGHT; y++, x += k ) {
						line = board[x];
						if ( line.length <= y ) {
							connect++;
							space++;
							s = (s << 1) & 0xF;
						}else{
							piece = line[y];
							if ( s == 0 || t != piece ) {
								t = piece; connect = 1 + space; s = 1;
							}else{
								connect++;
								s = ((s << 1) + 1) & 0xF;
							}
							space = 0;
						}
						if ( connect >= CONNECT ) {
							n += ((t == turn) ? 1.5 : -1) * table[s];
						}
					}
				}
			}
			for ( k = -1; k < 2; k += 2 ) {
				xx = (k < 0) ? (WIDTH - 1) : 0;
				for ( i = HEIGHT; i >= CONNECT; i-- ) {
					connect = 0;
					space = 0;
					s = 0;
					for ( x = xx, y = i - 1; y >= 0; y--, x += k ) {
						line = board[x];
						if ( line.length <= y ) {
							connect++;
							space++;
							s = (s << 1) & 0xF;
						}else{
							piece = line[y];
							if ( s == 0 || t != piece ) {
								t = piece; connect = 1 + space; s = 1;
							}else{
								connect++;
								s = ((s << 1) + 1) & 0xF;
							}
							space = 0;
						}
						if ( connect >= CONNECT ) {
							n += ((t == turn) ? 1.5 : -1) * table[s];
						}
					}
				}
			}
			
			if ( table[0x10] < n ) { n = table[0x10]; }
			if ( -table[0x10] > n ) { n = -table[0x10]; }
		
			return n;
		}
		
		
		/** 着手 */
		public function move( m:Move ):void {
			wait = false;
			m.prev = last;
			last = m;
			m.game = this;
			
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
			var p:Array = movable();
			wait = true;
			brains[ int(turn) ].think( p ); //brainに着手を申請
		}
		
		/** 着手候補を挙げる　*/
		public function movable():Array {
			if ( finished ) { return []; }
			
			var ms:Array, m:Move;
			if ( (ms = _movables) && (log == last) ) { return ms; }
			
			log = last;
			ms = [];
			if ( passCount == 0 ) {
				ms.push( m = new Move( -1 ) );
				m.prev = last;
			}
			for ( var i:int = 0; i < WIDTH; i++ ) {
				if ( board[i].length != HEIGHT ) { 
					m = new Move( i )
					ms.push( m ); 
					m.prev = last;
				}
			}
			return (_movables = ms);
		}
		private var _movables:Array;			//着手候補のログ
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
			var p:Array = movable();
			if ( p.length == int( passCount == 0 ) ) {
				finished = true;
				winner = 0;
				return;
			}
		}
		
		/** 1手戻る　*/
		public function back():void {
			if (! last || last.value === null ) { return; }
			if( brains ) brains[ int(turn) ].stop();
			
			var m:Move = last;
			if( m.value >= 0 ) board[ m.value ].pop();
			m = last = m.prev;
			
			for ( var p:int = PASS_COUNT; p > 0; p-- ) {
				if ( m.value === null ) { p--; break; }
				if ( m.value == -1 ) { break; }
				m = m.prev;
			}
			passCount = p;
			
			turn = !turn;
			wait = false;
			finished = false;
		}
		
		public function clone():Game {
			var game:Yonmoku = new Yonmoku( null, null );
			_copyTo( game );
			return game;
		}
		public function copyTo( game:Game ):void {
			if (! game is Yonmoku ) { return; }
			_copyTo( game as Yonmoku );
		}
		
		public function _copyTo( game:Yonmoku ):void {
			game.passCount = passCount;
			game.last = last;
			game.turn = turn;
			game.finished = finished;
			game.winner = winner;
			
			for ( var i:int = 0; i < WIDTH; i++ ) {
				var v1:Vector.<Boolean> = board[i], v2:Vector.<Boolean> = game.board[i];
				var j:int, l1:int = v1.length, l2:int = v2.length;
				if ( l1 < l2 ) {
					v2.length = l1;
				}else {
					for ( j = l2; j < l1; j++ ) { v2[j] = v1[j]; }
					l1 = l2;
				}
				for ( j = 0; j < l1; j++ ) { v2[j] = v1[j]; }
			}
		}
		
		/** 最後の着手を得る */
		public function getMove():Move {
			return last;
		}
	}
}