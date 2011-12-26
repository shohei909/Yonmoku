package yonmoku{
	public interface Game {
		function evaluate( ...args ):Number;	//評価関数
		function movable():Vector.<Move>;		//着手可能な手を選び出す
		function move( value:Move ):void;		//着手を行う。
		function progress():Move;				//ゲームを進行させる
	}
}