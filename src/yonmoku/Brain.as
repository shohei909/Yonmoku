package yonmoku{
	/** 知能 */
	public class Brain {
		public var target:Game;
		function Brain(){}
		
		/** 自分の打てる手(moves)の中から、打つべき着手を探す。 */
		public function think( moves:Vector.<Move> ):Move {
			return null;
		}
		
		/** 思考中ならば中止 */
		public function stop():void {}
	}
}