package yonmoku{
	/** 着手を表すクラス */
	public class Move {
		public var prev:Move;
		public var value:Object;
		
		/* 以下、思考用一時データ。 */
		public var game:Game;		//親となっているゲーム
		public var point:Number;	//この着手の評価値
		public var alpha:Number;	//この着手の評価値
		public var next:Array;		//次の着手としてありうるもの
		
		function Move( value:Object ) { this.value = value; }
	}
}