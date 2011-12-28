package yonmoku.viewer {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**　アイコンボタンのリスト　*/
	public class IconList extends Sprite{
		private var _index:int = 0;
		public function set index( i:int ):void { 
			if ( _index == i ) { return; }
			_index = i;
			frame.x = (fw + interval) * i;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		public function get index():int { return _index; }
		
		public var list:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		public var frame:Shape;
		public var fw:int, fh:int, interval:int;
		
		function IconList( list:Array, fw:int = 65, fh:int = 65, interval:int = 10 ) {
			this.fw = fw; this.fh = fh; this.interval = interval;
			addChild( frame = new Shape );
			var g:Graphics = frame.graphics;
			g.lineStyle( 4, 0xFF4400 );
			g.drawRoundRect( 0, 0, fw, fh, fw / 3, fh / 3 );
			
			for ( var i:int = 0, l:int = list.length; i < l; i++ ) {
				addIcon( list[i] );
			}
		}
		
		public function addIcon( icon:DisplayObject ):void {
			icon.x = ( (fw + interval) * this.list.length ) + (fw - icon.width) / 2;
			icon.y = ( fh - icon.height ) / 2;
			list.push( icon );
			trace( icon, list )
			addChild( icon );
			icon.addEventListener( MouseEvent.MOUSE_DOWN, onClick);
		}
		
		public function onClick(e:Event): void {
			index = list.indexOf( e.target );
		}
	}

}