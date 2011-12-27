package yonmoku.brain {
	import yonmoku.Brain;
	import yonmoku.Move;
	
	/** 何も考えないAI */
	public class FoolAI extends Brain {
		
		/** 与えられた手からランダムで一つ選ぶ。　*/
		override public function think( moves:Vector.<Move> ):void {
			target.move( moves[ int(moves.length * Math.random()) ] );
		}
	}
}