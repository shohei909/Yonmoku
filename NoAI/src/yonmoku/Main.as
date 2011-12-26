package yonmoku{
	import flash.display.Graphics;
	import yonmoku.brouser.Brouser;
	import yonmoku.viewer.*;
	import yonmoku.brain.*;
	
	[SWF(width="480", height="360")]
	public class Main extends Brouser {
		public var viewer:Viewer;
		function Main() {
			Data.load();
			Data.onLoaded = init;
		}
		public function init():void {
			var g:Graphics = graphics;
			g.beginBitmapFill( Data.image["back"]["stage"] );
			g.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			
			addChild( 
				viewer = new Viewer( 
					new Person("PLAYER1", Data.image["man"]["nobody"], new Human() ) ,
					new Person("PLAYER2", Data.image["man"]["nobody"], new Human() )
				)
			);
		}
	}
}