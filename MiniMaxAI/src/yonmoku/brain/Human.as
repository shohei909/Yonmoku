package yonmoku.brain {
	import yonmoku.*;
	import yonmoku.viewer.*;
	
	public class Human extends Brain {
		public var thinking:Boolean;
		private var moves:Array;
		
		function Human() {}
		
		override public function think( moves:Array ):void{
			thinking = true;
			this.moves = moves;
		}
		override public function stop():void {
			thinking = false;
		}
		
		public function move( value:int ):void {
			if (! thinking ) { return; }
			for each( var m:Move in moves ) {
				if ( m.value == value ) {
					thinking = false;
					target.move( m );
				}
			}
		}
	}
}