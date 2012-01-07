package yonmoku.brain {
	import yonmoku.*;
	import flash.utils.getTimer;
	
	/** 
	 * ミニマックス法AIと見せかけて、実際はネガアルファ法。
	 **/
	public class RandomAI extends Brain{
		static private var gamePool:Vector.<Game> = new Vector.<Game>(); 	//ゲームの使い回し用のプール
		public var table:Array; 					//得点評価用のテーブル。
		public var limit:int;						//先読みの上限となる手の数
		public var rate:Number;						//間引きする率。
		
		function RandomAI( rate:Number, limit:int, table:Array ):void { 
			this.table = table;
			this.limit = limit;
			this.rate = rate;
		}
		
		/** 
		 * 自分が打てる手のリスト(moves)を受け取って、
		 * その中から一つ手を選んでゲーム(target)に渡す。
		 **/
		override public function think( moves:Array ):void {
			var time:int = getTimer()
			var root:Move = target.getMove();
			root.next = moves;
			
			var layer:Array = moves, heap:Array = [ layer ], low:Array;
			var l:int = layer.length, i:int, count:int = 0, m:Move, g:Game, depth:int = 0;
			target.getMove().point = NaN;
			
			//木を作成
			do {
				low = layer;
				layer = [];
				for ( i = 0; i < l; i++ ) {
					m = low[i];
					m.point = NaN;
					g = m.prev ? m.prev.game.clone() : target.clone();
					g.move( m );
					layer.push.apply( null, m.next = g.movable() );
				}
				heap.push( layer );
				l = layer.length;
				depth++;
			}while ( 0 < l && l < limit );
			
			//評価値の付加
			_evaluateHeap( root, -Infinity, depth );
			
			//一番良い手を配列で返す。
			var a:Array = _minimum( moves );
			
			target.move( a[ int( a.length * Math.random() ) ]  );
		}
		
		private function _evaluateHeap( move:Move, alpha:Number, deepest:int, depth:int = 0 ):void {
			var task:Array;
			if (! (task = move.next) ) {
				if ( Math.random() > rate ) { return; }
				var g:Game = move.prev.game.clone();
				g.move( move );
				move.point = g.evaluate( table );
			}else if ( task.length == 0 ) {
				move.point = move.game.evaluate( table ) * ( (10000 + deepest) / (10000 + depth) );
			}else{
				var min:Number = Infinity;
				for ( var i:int = 0, l:int = task.length; i < l; i++ ) {
					if ( min < alpha ) { return; }
					var next:Move = task[i];
					_evaluateHeap( next, -min, deepest, depth + 1 );
					var p:Number = next.point;
					if ( p < min ) { min = p; }
				}
				if ( min == Infinity ) {
					move.point = move.game.evaluate( table );
				}else{
					move.point = -min;
				}
			}
			
		}
		
		private function _minimum( moves:Array ):Array {
			var a:Array = [];
			var min:Number = Infinity;
			for ( var i:int = 0, l:int = moves.length; i < l; i++ ) {
				var move:Move = moves[i];
				var p:Number = move.point;
				if ( p < min ) {
					min = p;
					a.length = 0
					a.push( move );
				}else if( p == min ){
					a.push( move );
				}
			}
			return a;
		}
		
	}
}