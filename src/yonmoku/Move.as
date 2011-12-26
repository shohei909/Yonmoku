package yonmoku{
	/** 着手 */
	public class Move {
		public var prev:Move;
		public var value:Object;
		function Move( value:Object ) { this.value = value; }
	}
}