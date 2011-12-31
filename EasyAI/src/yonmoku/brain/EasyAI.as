package yonmoku.brain {
	import yonmoku.*;
	
	/** 簡単なAI */
	public class EasyAI extends Brain{
		private var clone:Game;	//現在の盤面のコピー。対戦をシミュレートするのに使う。
		public var table:Array; //得点評価用のテーブル。
		
		function EasyAI( table:Array ):void { 
			this.table = table; 
		}
		
		/** 
		 * 自分が打てる手のリスト(moves)を受け取って、
		 * その中から一つ手を選んでゲーム(target)に渡す。
		 **/
		override public function think( moves:Vector.<Move> ):void {
			if (! clone ) { clone = target.clone(); }
			else { target.copyTo( clone ); }
			
			var max:Number = int.MIN_VALUE, v:Vector.<int> = new Vector.<int>();
			for ( var i:int = 0, l:int = moves.length; i < l; i++ ) {
				clone.move( moves[i] );
				var n:int = -clone.evaluate( table );
				if ( n > max ) { 
					max = n;
					v.length = 0;
					v.push( i );
				}else if( n == max ){
					v.push( i );
				}
				clone.back();
			}
			
			target.move( moves[ v[ int( v.length * Math.random() ) ] ] );
		}
	}

}