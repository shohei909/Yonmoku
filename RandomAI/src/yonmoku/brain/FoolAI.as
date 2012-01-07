package yonmoku.brain {
	import yonmoku.Brain;
	import yonmoku.Move;
	
	public class FoolAI extends Brain {
		/** 
		 * 自分が打てる手のリスト(moves)を受け取って、
		 * その中から一つ手を選んでゲーム(target)に渡す。
		 **/
		override public function think( moves:Array ):void {
			target.move( moves[ int(moves.length * Math.random()) ] );
		}
	}
}