package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Bane extends MovieClip {
		
		
		public function Bane() {
			addEventListener(Event.ADDED_TO_STAGE, leggTilBane);
		}
		function leggTilBane(evt:Event){
			y=600;
			trace(y);
		}
	}
	
}
