package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Armer extends MovieClip {
		
		
		public function Armer() {
			y=-12;
			addEventListener(Event.ENTER_FRAME, oppdaterAremene);
		}
		function oppdaterAremene(evt:Event){
			//om main sniper er valgt
			if(MovieClip(parent).aktivVapenId==1){
				//hvor hånd 1 er på main sniper(den som går kortest).
				var hand1= new Point(  (Math.cos(MovieClip(parent).rotasjonvapen*Math.PI/180))*6+3  ,(Math.sin(MovieClip(parent).rotasjonvapen*Math.PI/180))*6-4);
				//hvor hånd 2 er på main sniper(den som går lengst).
				var hand2= new Point(  (Math.cos(MovieClip(parent).rotasjonvapen*Math.PI/180))*12+3  ,(Math.sin(MovieClip(parent).rotasjonvapen*Math.PI/180))*12-4);
				//tegner armene om og om igjen
				graphics.clear();
				graphics.lineStyle(0.8,0x1B1B1B,1);
				graphics.moveTo(0,0);
				graphics.lineTo(hand1.x,hand1.y);
				graphics.moveTo(0,1);
				graphics.lineTo(hand2.x,hand2.y);
			}
		}
	}
	
}
