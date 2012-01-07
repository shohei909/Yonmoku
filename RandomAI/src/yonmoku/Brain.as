package yonmoku{
	/** 知能用クラス。継承して使う。 */
	public class Brain {
		public var target:Game;
		
		/** 自分の打てる手(moves)の中から、打つべき着手を探す。 */
		public function think( moves:Array ):void {}
		
		/** 思考中ならば中止 */
		public function stop():void {}
	}
}
