package yonmoku.viewer{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import yonmoku.*;
	import yonmoku.brain.Human;
	import yonmoku.brouser.Page;
	
	/**
	 * 四目並べの表示スプライト
	 */
	public class Viewer extends Page {
		static public const WIDTH:int = 480;
		static public const HEIGHT:int = 360;
		
		public var source:Yonmoku;
		public var field:Field;
		public var wait:int;		//待機
		
		public var players:Vector.<Player>;		//プレイヤー窓
		public var people:Vector.<Person>;		//個人データ
		public var pieces:Vector.<BitmapData>;		//ピース用データ
		
		public var last:Move;			//直前の着手
		public var log:Vector.<Move>;	//これまでの着手ログ
		public var step:int;			//現在の手数
		
		public var human:Human;
		
		public var passBtn:TextButton;
		public var btns:Object = {}
		public var results:Vector.<Text>;
		
		public var finished:Boolean = true;
		
		public static const drawFilter:GlowFilter = new GlowFilter( 0xFFCC00, 1, 8, 8, 16 );
		public static const winFilter:GlowFilter = new GlowFilter( 0xFF6633, 1, 8, 8, 16 );
		public static const loseFilter:GlowFilter = new GlowFilter( 0x3366FF, 1, 8, 8, 16 );
		
		function Viewer( p1:Person, p2:Person ):void {
			this.source = new Yonmoku( p1.brain, p2.brain );
			people = Vector.<Person>([ p1, p2 ]);
			setPiece();
			
			//フィールドを設定
			addChild( field = new Field( this ) );
			field.scaleX = field.scaleY = 1;
			field.x = (WIDTH - field.width) / 2;
			field.y = 30;
			
			addEventListener( Event.ENTER_FRAME, _onFrame, false, 0, true );
			field.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			field.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			field.addEventListener( MouseEvent.CLICK, onClick );
			
			
			setPlayer();
			
			//ボタン
			var btn:TextButton;
			addChild( btn = passBtn = new TextButton( "PASS", pass) );
			btn.y = HEIGHT - 45; btn.x = (WIDTH - btn.width) / 2;
			
			var arr:Array = [ "new", "first", "undo", "redo", "end" ];
			var ts:Array = [ "NEW","さいしょ","もどる","すすむ","さいご"]
			var fs:Array = [ newGame, first, undo, redo, end ];
			var l:int = arr.length;
			
			for ( var i:int = 0; i < l; i++ ) {
				var icon:IconButton;
				addChild( icon = new IconButton( Data.image["move"][arr[i]], ts[i], fs[i] ) );
				icon.x = 5 + WIDTH / 2 + 36 * (i - l / 2); icon.y = HEIGHT - 37;
				btns[arr[i]] = icon;
			}
			
			log = new Vector.<Move>();
			update();
		}
		
		//フレームごとの動作
		private function _onFrame(e:Event):void {
			if ( wait > 0 ) { wait--; return }
			if ( source.last != last ) { update(); }
		}
		
		private function newGame():void {
			this.source = new Yonmoku( people[0].brain, people[1].brain );
			setPiece();
			setPlayer();
			
			log = new Vector.<Move>();
			step = 0;
			update();
		}
		
		private function setPiece():void {
			//ピースに使う画像をランダムに選択
			var pa:Array = Data.IMG[0][1];
			var n:int = pa.length;
			var i1:int = Math.random() * n;
			var i2:int = Math.random() * --n;
			if ( i1 <= i2 ) { i2++; }
			pieces = Vector.<BitmapData>([ Data.image["piece"][pa[i1]], Data.image["piece"][pa[i2]] ]);
		}
		
		/** プレーヤーの表示 */
		private function setPlayer():void {
			if( players ){
				while ( players.length > 0 ) { removeChild( players.pop() ); }
			}
			
			var fw:int = field.width;
			var pw:int = (WIDTH - field.width) / 2;
			players = new Vector.<Player>;
			results = new Vector.<Text>;
			for ( var i:int = 0; i < 2;  i++ ) {
				var p:Player;
				
				addChild( p = new Player( this, i == 1 ) );
				p.x = i * (pw + fw) + (pw - p.width) / 2;
				p.y = ( HEIGHT - p.height ) / 2;
				players.push(p);
				
				var t:Text = new Text( "", 13, 0xFFFFFF, "center" );
				t.x = p.width / 2;
				t.y = 110;
				t.filters = [ drawFilter ];
				p.addChild( t );
				results.push( t );
			}
		}
		
		public function update():void {
			last = source.last;
			var index:int = log.indexOf( last );
			if ( index < 0 ) {
				var v:Vector.<Move> = new Vector.<Move>;
				var m:Move = last;
				do{
					v.push( m );
				}while ( m && 0 <= log.indexOf( m = m.prev ) );
				log.splice( index + 1, uint.MAX_VALUE );
				var l:int = v.length;
				for ( i = 0; i < l; i++ ) { log.push( v.pop() ); }
				step = index + l + 1;
			}else { step = index + 1; }
			
			human = source.brains[ int( source.turn ) ] as Human;
			for ( var i:int = 0; i < 2; i++ ) { players[i].draw( !source.finished && (source.turn == (i != 0)) ); }
			
			field.update();
			passBtn.enable = (!source.finished && source.passCount == 0);
			btns.undo.enable = btns.first.enable = Boolean( last );
			btns.redo.enable = btns.end.enable = ( step != log.length );
			
			if ( finished != source.finished ) {
				finished = source.finished
				var text:Text;
				if( finished ){
					var arr:Array = [["DRAW", "DRAW"], ["WIN", "LOSE"], ["LOSE", "WIN"]][source.winner];
					var filter:Array = [[ drawFilter, drawFilter], [ winFilter,loseFilter], [loseFilter, winFilter]][source.winner];
					for ( i = 0; i < 2; i++ ) {
						text = results[i];
						text.setText( arr[i] );
						text.filters = [ filter[i] ]
					}
				}else {
					for ( i = 0; i < 2; i++ ) {
						text = results[i];
						text.setText( "" );
						text.filters = []
					}
				}
			}
			source.progress();
			onMouseMove( null );
		}
		
		public function onMouseMove( e:Event ):void {
			if (! human || !human.thinking ) { return; }
			field.hint( true );
		}
		
		public function onMouseOut( e:Event ):void {
			//if (! human ) { return; }
			field.hint( false );
		}
		
		public function onClick( e:Event ):void {
			if (! human || !human.thinking ) { return; }
			field.move( human );
		}
		
		public function pass():void {
			if (! human || !human.thinking ) { return; }
			human.move( new Move( -1 ) );
		}
		
		public function undo():void {
			source.back();
			update();
		}
		public function first():void {
			while ( source.last ) { source.back(); }
			update();
		}
		public function redo():void {
			source.brains[ int(source.turn) ].stop();
			source.move( log[ step ] );
			update();
		}
		public function end():void {
			source.brains[ int(source.turn) ].stop();
			for ( var i:int = step, l:int = log.length; i < l; i++ ) {
				source.move( log[ i ] ); 
			}
			update();
		}
	}
}