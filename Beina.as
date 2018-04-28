package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Beina extends MovieClip {
		
		//Point der bein festes til kroppen
		var bein_feste = new Point(0,-8);
		//høyre fot
		var bein_h= new Point(4,0);
		
		public function Beina() {
			addEventListener(Event.ENTER_FRAME, oppdaterBeina);
		}
		function oppdaterBeina(evt:Event){
			//får beine til å bevege seg like raskt som spilleren beger seg. går også slik at farten alltid er positiv
			if(MovieClip(parent).v_loping<0){
				bein_h.x+=MovieClip(parent).v_loping;
			}
			else{
				bein_h.x-=MovieClip(parent).v_loping;
			}
			if(bein_h.x<-4){
				bein_h.x=4;
			}
			if(bein_h.x>4){
				bein_h.x=-4;
			}
			if(MovieClip(parent).v_loping==0){
				bein_h.x=0;
			}
			
			
			//---------------------------------------------------------------------------
			//tegner beina om og om igjen
			graphics.clear();
			graphics.lineStyle(0.8,0x000000,1);
			graphics.moveTo(bein_feste.x,bein_feste.y);
			graphics.lineTo(bein_h.x,bein_h.y);
		}
	}
	
}
