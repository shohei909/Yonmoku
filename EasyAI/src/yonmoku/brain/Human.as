package yonmoku.brain {
	import yonmoku.*;
	import yonmoku.viewer.*;
	
	public class Human extends Brain {
		public var thinking:Boolean;
		function Human() {}
		
		override public function think( moves:Vector.<Move> ):void{
			thinking = true;
		}
		override public function stop():void {
			thinking = false;
		}
		
		public function move( m:Move ):void {
			if (! thinking ) { return; }
			thinking = false;
			target.move( m );
		}
	}
}