package yonmoku.viewer {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	public class Button extends Sprite{
		public static const glow:GlowFilter = new GlowFilter( 0xFF8800, 1, 8, 8 );
		public static const mono:ColorMatrixFilter = new ColorMatrixFilter( [ 0.3, 0.3, 0.3, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0, 0, 0, 0.4, 0 ] );
		
		public var over:Boolean;
		public var onClick:Function;
		
		public function set enable( b:Boolean ):void {
			mouseEnabled = b;
			mouseChildren = b;
			buttonMode = b;
			update();
		}
		public function get enable():Boolean {
			return mouseEnabled;
		}
		
		public function Button( onClick:Function = null ) {
			this.onClick = onClick;
			filters = [];
			enable = true;
			addEventListener( MouseEvent.CLICK, click, false, 0, false );
			addEventListener( MouseEvent.MOUSE_OVER, onOver, false, 0, false );
			addEventListener( MouseEvent.MOUSE_OUT, onOut, false, 0, false );
		}
		
		public function update():void {
			var f:Array = [];
			if (! mouseEnabled ) { f.push( mono ) }
			if ( over ) { f.push( glow ) }
			filters = f;
		}
		
		private function click( e:Event ):void {
			if ( onClick != null ) { onClick(); }
		}
		
		private function onOver( e:Event ):void {
			over = true;
			update();
		}
		private function onOut( e:Event ):void {
			over = false;
			update();
		}
	}
}