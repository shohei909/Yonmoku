package yonmoku{
	import flash.display.Graphics;
	import yonmoku.brouser.Brouser;
	import yonmoku.viewer.*;
	import yonmoku.brain.*;
	
	[SWF(width="480", height="360")]
	public class Main extends Brouser {
		public var viewer:Viewer;
		function Main() {
			Data.setupImage();
			init();
		}
		
		public function init():void {
			var g:Graphics = graphics;
			g.beginBitmapFill( Data.image["back"]["stage"] );
			g.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			
			open( 
				viewer = new Viewer()
			);
		}
	}
}