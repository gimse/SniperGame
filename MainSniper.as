package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MainSniper extends MovieClip {
		//fasten den skal rotere
		var v_rotasjon:int=2;
		var nedkjøling:int=0;
		const nedkjøling_max=3;
		//------------------------------------------------------------------------
		
		
		public function MainSniper() {
			//når den legger til sniperen.
			addEventListener(Event.ADDED_TO_STAGE, mainSniperErLagtTil);
		}
		function mainSniperErLagtTil(evt:Event){
			//setter hvor den er på spilleren
			x=4;
			y=-16,05;
			//legger til en entter frame
			addEventListener(Event.ENTER_FRAME, beveg_MainSniper);
			addEventListener(Event.REMOVED_FROM_STAGE, fjern_MainSniper);
		}
		//når den fjenes fra senen
		function fjern_MainSniper(evt:Event){
			removeEventListener(Event.ENTER_FRAME, beveg_MainSniper);
			removeEventListener(Event.REMOVED_FROM_STAGE, fjern_MainSniper);
		}
		//------------------------------------------------------------------------------
		
		
		function beveg_MainSniper(evt:Event){
			//beveger sniperen opp. referer til varialblen på spilleren.
			//opp:
			if((MovieClip(parent).spiller_tast_nede[0])==true && rotation >-90){
				//roter gun
				rotation-=v_rotasjon;
			}
			//ned:
			if((MovieClip(parent).spiller_tast_nede[1])==true && rotation <90){
				//roterer gun
				rotation+=v_rotasjon;
			}
			//når spilleren skyter(trykker space);
			if((MovieClip(parent).spiller_tast_nede[5])==true && rotation <90){
				//nedkjøling
				if(nedkjøling==0){
					//utløser funkonen på Dokument Class
					MovieClip(root).leggTilkule(0,x+MovieClip(parent).x,y+MovieClip(parent).y,rotation+MovieClip(parent).rotation,MovieClip(parent).pekerMotHoyre);
					nedkjøling=nedkjøling_max;
				}
			}
			//kjøler ned sniperen etter at den er skutt(hinder at det blir at maskin gevær)
			if(nedkjøling>0){
				nedkjøling--;
			}
		}
	}
}