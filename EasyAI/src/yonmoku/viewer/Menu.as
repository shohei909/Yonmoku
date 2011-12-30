package yonmoku.viewer {
	import flash.display.Sprite;
	import flash.events.Event;
	import yonmoku.brain.EasyAI;
	import yonmoku.brain.FoolAI;
	import yonmoku.brain.Human;
	import yonmoku.Data;
	public class Menu extends Sprite {
		public var viewer:Viewer;
		public var people:Array = [];
		public var selected:Vector.<int>;
		public var lists:Vector.<IconList> = new Vector.<IconList>;
		
		function Menu( viewer:Viewer ) {
			this.viewer = viewer;
			
			//ボタン
			var arr:Array = [ "back", "new", "spin" ];
			var ts:Array = [ "もどる", "NEW", "こうたい" ]
			var fs:Array = [ back, newGame, spin ];
			var l:int = arr.length;
			
			for ( var i:int = 0; i < l; i++ ) {
				var icon:IconButton;
				addChild( icon = new IconButton( Data.image["move"][arr[i]], ts[i], fs[i] ) );
				icon.x = 20 + Viewer.WIDTH / 2 + 62 * (i - l / 2); icon.y = Viewer.HEIGHT - 70;
			}
			
			var a1:Array = ["さき", "あと"];
			for ( i = 0; i < 2; i++ ) {
				var text:Text;
				var a2:Array = [
					new Person( "プレーヤー", Data.image["man"]["nobody"], new Human() ),
					new Person( "AI 2号", Data.image["head"]["easy"], new EasyAI() ),
					new Person( "AI 1号", Data.image["head"]["fool"], new FoolAI() ),
				]
				
				l = a2.length;
				addChild( text = new Text( a1[i], 10, 0 ) );
				text.x = 110; 　text.y = 50 + 110 * i;
					var icons:Array = [];
				for ( var j:int = 0; j < l; j++ ) {
					var p:Person = a2[j];
					icon = new IconButton( p.face, p.name, null, 4 );
					icon.scaleX = icon.scaleY = 2;
					icons.push( icon );
				}
				
				var list:IconList;
				addChild( list = new IconList( icons ) );
				list.x = (Viewer.WIDTH - list.width) / 2; list.y = 50 + 110 * i;
				list.addEventListener( Event.CHANGE, onChange, false, 0, true );
				lists.push( list );
				
				people.push( a2 );
				
				viewer.people[i] = people[i][0];
			}
		}
		
		private function back():void {
			viewer.brouser.close();
		}
		
		private function spin():void {
			var tmp:int = lists[0].index;
			lists[0].index = lists[1].index;
			lists[1].index = tmp;
		}
		
		private function newGame():void {
			viewer.newGame();
			viewer.brouser.close();
		}
		
		private function onChange( e:Event ):void { 
			var i:int = lists.indexOf( e.target );
			viewer.people[i] = people[i][ lists[i].index ]
		}
	}
}