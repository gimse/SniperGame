package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Dokument extends MovieClip {
		
		var testtreff:MovieClip= new Testtreff();
		
		//informasjon om findene
		var findeOppsett:Array= new Array();
		var finder:Array=new Array();
		var skytbareTing:Array=new Array();
		
		//-----------------------------------------
		//solide vegger og bakke legges til
		var flatbakke:MovieClip= new Flatbakke();
		var solidvenstrevegg:MovieClip= new Solidvenstrevegg();
		var solidhoyrevegg:MovieClip= new Solidhoyrevegg();
		//-----------------------------------------
		// constructor code
		public function Dokument() {
			addEventListener(Event.ENTER_FRAME, oppdater);
			lagBane(0);
		}
		//skal konstruere banen
		function lagBane(baneid){
			//---------------------------------------------------------------
			//legg til solide vegger og bakke
			flatbakke.y=600;
			addChild(flatbakke);
			solidvenstrevegg.y=600;
			addChild(solidvenstrevegg);
			solidhoyrevegg.y=600;
			addChild(solidhoyrevegg);
			
			//----------------------------------------------------------------
			//legger til info om finer
			if(baneid==0){
				skytbareTing=[flatbakke,solidhoyrevegg,solidvenstrevegg];
				//legger til ifo om spillerene
				//-----------------x---y--rotation
				findeOppsett[0]= new Array(400,500,0);
				findeOppsett[1]= new Array(300,190,0);
				findeOppsett[2]= new Array(450,580,0);
				findeOppsett[3]= new Array(200,100,0);
				//-------------------------------------------------
				//legger tl findene
				for(var n:int=0;n<findeOppsett.length;n++){
					var finde=new Finde();
					finde.x=findeOppsett[n][0];
					finde.y=findeOppsett[n][1];
					skytbareTing.push(finde);
					addChild(finde);
				}
			}
			
		}
		function oppdater(evt:Event){
			//-------------------------------------------------------------------
			//om spilleren er på bakken, venstre gegg eller høyre vegg. infoen sender til spillren
			//registerer om spilleren er i bakken
			if(flatbakke.hitTestPoint(spiller.x, spiller.y, true)){
			   spiller.paBakken=true;
			}
			else{
				 spiller.paBakken=false;
			}
			//registerer om spilleren er i venstre vegg
			if(solidvenstrevegg.hitTestPoint(spiller.x-10, spiller.y, true)){
			   spiller.paVensteVegg=true;
			}
			else{
				 spiller.paVensteVegg=false;
			}
			//registerer om spilleren er i høyre vegg
			if(solidhoyrevegg.hitTestPoint(spiller.x+10, spiller.y, true)){
			   spiller.paHoyreVegg=true;
			}
			else{
				 spiller.paHoyreVegg=false;
			}
			//------------------------------------------------------------------------
		}
		//den legger til en kule. Den får inn hvor kulen starter og reningen, og ser om den kuluderer med noe
			public function leggTilkule(spiller,x_posision,y_posision,retning,pekerMotHoyre){
				//regner ut stigningstallet i forhold til raotasjoen til våpene.
				var tid:Number=0;
				//blir false når kulen treffer noe. den ikke kan gå igjennom
				var kuleKoludert:Boolean=false;

				//en parameter fremstilling over posisonen til kulen
				var x_kule:Number;
				var y_kule:Number;
				//finner ut hvilken retning kulen går. den variablen tar i med om spilleren vender andre veien
				var retning_kule:Number;
				if(pekerMotHoyre==true){
					retning_kule=retning;
				}
				else{
					retning_kule=180-retning;
				}
				tid=0;
				x_kule=0;
				y_kule=0;
				//gjører den så lenge dden ikke treffer på noe
				while(0<=x_kule && x_kule<=800 && 0<=y_kule && y_kule<=600 && kuleKoludert==false){
					x_kule=x_posision+Math.cos(Math.PI*retning_kule/180)*tid;
					y_kule=y_posision+Math.sin(Math.PI*retning_kule/180)*tid;
					for (var c:int=0;c<skytbareTing.length;c++){
						//om kulen koluderer med en skytbarting
						if(skytbareTing[c].hitTestPoint(x_kule,y_kule,true)){
							//om den treffer noe solid
							if(c<=3){
								kuleKoludert=true;
							}
							else{
								skytbareTing[c].x-=5;
							}
							testtreff.x=x_kule;
							testtreff.y=y_kule;
							addChild(testtreff);
						}
						tid+=0.1;
					}
				}
			} 
	}
}
