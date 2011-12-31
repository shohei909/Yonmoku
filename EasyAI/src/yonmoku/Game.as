package yonmoku {
	/** 思考の対象となるゲームのインターフェース */
	public interface Game {
		function evaluate( table:Array = null ):Number;	//評価関数
		function movable():Vector.<Move>;		//着手可能な手を選び出す
		function move( value:Move ):void;		//着手を行う。
		function progress():void;				//ゲームを進行させる
		function copyTo( target:Game ):void		//gameをコピー
		function clone():Game					//gameの複製を返す。
		function back():void					//直前の着手を取り消す。
	}
}