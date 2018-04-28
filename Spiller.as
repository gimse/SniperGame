package  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.utils.*;
	
	
	public class Spiller extends MovieClip {
		//-------------------------------------------------------------
		//variablen som innerholder hvilkene som skal styre spillen(0:opp,1:ned,2:venstre,3:høyre,4:s(hoppe),5:space(skyte),6:1(forige våpen,7:2(neste våpen))
		var spiller_taster:Array =[38,40,37,39,83,32,49,50];
		//var true når tasten er nede. henger sammen med var over
		public var spiller_tast_nede:Array=[false,false,false,false,false,false,false,false];
		
		//variabler til spillerens armer og bein:
		
		
		//spiller farten: (Den skal ikke være over 5)
		//akselarasjonen til løping(funker på x og y)
		var a_loping:Number=0.1;
		var t_loping:Number=0;
		var v_loping:Number=0;
		var v0_loping:Number=0;
		var vx_loping:Number=0;
		var vy_loping:Number=0;
		
		//den totale farten til spielleren
		var vx_total:Number;
		var vy_total:Number;
		
		//rotasjon i rad
		var rotasjon_rad:Number =(rotation*Math.PI)/180;
		
		//Om spilleren  er på noe, eller ikke
		var paBakken:Boolean = false;
		var paVensteVegg:Boolean=false;
		var paHoyreVegg:Boolean=false;

		//tyngekreaft akselerasjonen
		var a_tyngdekraft:Number = 0.5;
		var t_tyngdekraft:Number = 0;
		var v_tyngdekraft:Number = 0;
		
		//hoppevariablene, er på en måte v0 til tyngdekraft akselerasjonen.
		//juster var lengre ned i koden
		var v0_hopp:int=0;
		var hopper:Boolean=false;
		
		//hvilket våpen som er valgt id
		public var aktivVapenId:int=1;
		//våpen oversikt
		var vapen:Array=[new Kniv(),new MainSniper()];
		//hvilket våtpen som er aktivt
		public var aktivVapen:MovieClip=vapen[aktivVapenId];
		
		//en variablen som tar rotasjoen til det aktive våpene og leger det til en variabel. denne brukes av hendene
		public var rotasjonvapen:Number=0; 
		
		//vairable som viser om spilleren peker mot høyre.
		var pekerMotHoyre:Boolean=true;
		
		
		//-----------------------------------------------------------------------------------
		//konstrukter:
		public function Spiller() {
			//tytter om den blir lagt til på senen.
			addEventListener(Event.ADDED_TO_STAGE, spillerErLagtTil);
		}
		//når spileren bli lagt til på stage
		function spillerErLagtTil(evt:Event){
			//eventlistener som lytter om tastene er nede og oppe
			stage.addEventListener(KeyboardEvent.KEY_DOWN, taster_nede);
			stage.addEventListener(KeyboardEvent.KEY_UP, taster_oppe);
			addEventListener(Event.ENTER_FRAME, spiller_bevegelse);
			//----------------------------------------------------
			//legger til armer:
			var armer:MovieClip=new Armer();
			addChild(armer);
			var beina:MovieClip= new Beina();
			addChild(beina);
			//legger til våpen
			addChild(aktivVapen);
			
			
		
		}
		//om tast er nede
		function taster_nede(evt:KeyboardEvent){
			for (var t1:int=0;t1<spiller_taster.length;t1++){
				if(evt.keyCode==spiller_taster[t1])
				spiller_tast_nede[t1]=true;
			}
		}
		//om tast er oppe
		function taster_oppe(evt:KeyboardEvent){
			for (var t2:int=0;t2<spiller_taster.length;t2++){
				if(evt.keyCode==spiller_taster[t2])
				spiller_tast_nede[t2]=false;
			}
		}
		function spiller_bevegelse(e:Event){
			
			//----------------------------------------------------------------------
			//Utregning av spillerens løping fart(bare løpingen
			
			//rengner ut farten til spilleren, som er av hengig av tiden ag akselerasjone
			v_loping=a_loping*t_loping;
			//hustere akselerasjonen
			if(spiller_tast_nede[2]==true && t_loping>-30){
				if (t_loping>0){
					t_loping-=4;
				}
				else{
					t_loping--;
				}
			}
			if(spiller_tast_nede[3]==true && t_loping<30){
				if (t_loping<0){
					t_loping+=4;
				}
				else{
					t_loping++;
				}
			}
			//De akselerer spilleren. Når han ikke løper
			if (spiller_tast_nede[2]==false && spiller_tast_nede[3]==false){
				if (t_loping<0){
					t_loping+=3;
				}
				if (t_loping>0){
					t_loping-=3;
				}
				//for å få t til å bli null når den er veldig nærme. Den runder av tallet.
				if(t_loping<3 && t_loping>-3){
					t_loping=0;
				}
			}
			//--------------------------------------------------------------------------
			//dekomponener spillerens løper far(bare løpingen). til x og y
			
			//rotasjon i rad
			rotasjon_rad =(rotation*Math.PI)/180;
			//regner ut løper farten i x og y i forhold til vinklen til spillrene
			vx_loping = v_loping*Math.cos(rotasjon_rad);
			vy_loping = v_loping*Math.sin(rotasjon_rad);
			
			
			//-----------------------------------------------------------------------
			//regner ut tyngekreften, og farten den får. Den er bare aktiv når "pabakken" er av
			if(paBakken==false){
				//renger ut farten i fallet
				v_tyngdekraft=a_tyngdekraft*t_tyngdekraft;
				//legger til tid
				t_tyngdekraft++;
			}
			else{
				//nullsetter tyngdekraften
				v_tyngdekraft=0;
				t_tyngdekraft=0;
				
				//Nullstiller spillernes V0_hopp hår han treffer bakken etter å ha hoppet
				if (hopper==false){
					v0_hopp=0;
				}
				
			}
			//----------------------------------------------------------------------
			//Hopp: den gir spilleren en fart opp, men bare når han er i bakken, og når S er nede
			if(paBakken==true && spiller_tast_nede[4]==true){
				//huster hupp høyden
				v0_hopp=-3;
				hopper=true;
				//det er en timer som hindrer oppe å gå om og om igjen
				setTimeout(stopHopp, 500);
			}

			//----------------------------------------------------------------------------
			//hoved koden for å flytte spilleren
			
			//fart fra løping+
			vx_total=vx_loping;
			//fart fra løping+fart fra tyngdekreften+hopping
			vy_total=vy_loping+v_tyngdekraft+v0_hopp;
			//legger til farten i x og y, og hinderer den i å gå igjennom vegger
			if ((vx_total>=0 && paHoyreVegg==false) || (vx_total<=0 && paVensteVegg==false)){
				x+=vx_total;
			}
			y+=vy_total;
			
			//-------------------------------------------------------
			//Bytter våpen til spilleren
			//går til det forige våpene, når 1 er spesset ned, og at det ikke er det føsrte våpene, og at 2 ikke er spesset ned
			if(spiller_tast_nede[6] && aktivVapenId!=0 && spiller_tast_nede[7]==false){
				//fjerner det forige våpene
				removeChild(aktivVapen);
				//går til det forrige våpene
				aktivVapenId--
				//ender aktig våpen virablen
				aktivVapen=vapen[aktivVapenId];
				//legger til det forrige våpene
				addChild(aktivVapen);
				
			}
			//det motsatte av den forrige. Den går til det neste våpene.
			if(spiller_tast_nede[7] && aktivVapenId!=vapen.length-1 && spiller_tast_nede[6]==false){
				//fjerner det forige våpene
				removeChild(aktivVapen);
				//går til det forrige våpene
				aktivVapenId++
				//ender aktig våpen virablen
				aktivVapen=vapen[aktivVapenId];
				//legger til det forrige våpene
				addChild(aktivVapen);
				
			}
			//oppdater rotasjon variblen(står mere om den der den lages!)brukes i posisonene til armene, og hode_mc rotasjonen
			rotasjonvapen=aktivVapen.rotation;
			
			//roterer hode etter våpene som er valgt
			hode_mc.rotation=rotasjonvapen;
			
			//roterer spilleren.når farten blir negativ og positiv
			//når spilleren løper motsatt vei
			if(v_loping<0){
				scaleX=-1;
				pekerMotHoyre=false;
			}
			//når spilleren løper mot høyre
			if(v_loping>0){
				scaleX=1;
				pekerMotHoyre=true;
			}
		}
		//-----------------------------------------------------------------------------
		function stopHopp(){
			//stopper hoppet. slik at ikke spilleren hopp om og om igjen
			hopper=false;
		}
	}
	
}
