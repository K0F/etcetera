
import java.io.InputStreamReader;

PImage logo;
Parser parser;
ArrayList entries;

String filenames[];
String path;

int W = 192*2;
int H = 108*2;
String tc = "00:02:11";

int lover = 0;
String text[];
PFont header,body;
float scroll,scrollTarget,maxH;

void keyPressed(){
	if(key==' '){
		try{
			ProcessBuilder pb = new ProcessBuilder("curl", "\"https://docs.google.com/spreadsheets/d/1CcyZM9IFepGnKqWFYXA5yRojejtrXtmbymbCWi3GFfE/export?gid=0&format=tsv\" > sklad_etc.tsv"+path+"/data/");
			Process proc = pb.start();
			proc.waitFor();
			entries = new ArrayList();
			parser = new Parser("sklad_etc.tsv"); 
		}catch(Exception e){
			println("reloading failed "+e);
		}
	}
}


void setup() {
	//size(displayWidth, displayHeight, P2D);
	size(1920, 1080, P2D);

	path = sketchPath()+"/";
	//filenames = getFiles(path+"videos");
	//println(filenames);

	//header = textFont(loadFont("MonacoForPowerline-10.vlw"));
	body = loadFont("FalsterGroteskReg-Regular-18.vlw");
	header = loadFont("FalsterGroteskReg-Regular-48.vlw");


	//println(display);

	logo = loadImage("logo.png");

	entries = new ArrayList();
	parser = new Parser("sklad_etc.tsv");
}



void draw() {
	background(255);
	image(logo, width-logo.width-40, 20);

	for (int i = 0; i < entries.size(); i++) {
		Entry tmp = (Entry)entries.get(i);

		pushMatrix();
		translate(0,-scroll);
		tmp.draw();
		popMatrix();

		if(lover==i)
			tmp.drawText();
	}

	scroll+=(scrollTarget-scroll)/10.0;
	if(scroll<0){
		scrollTarget+=(0-scrollTarget)/5.0;
	}else if(scroll>maxH){
		scrollTarget+=(maxH-scrollTarget)/5.0;

	}
}

/*
   videos = new ArrayList();

   int x = 50, y = 50;
   for (int i = 0; i < filenames.length; i++) {
   videos.add(new Thumbnail(filenames[i], x, y, i));
   x += W + 20;
   if (x>width-W-200) {
   x=50;
   y+=H+20;
   }
   }

 */

class Parser{

	String filename;
	String [] raw;

	Parser(String _filename){
		filename = _filename;
		raw = loadStrings(filename);
		// global
		entries = getList();
	}

	ArrayList getList(){
		ArrayList tmp = new ArrayList();
		int x = 50, y = 50;
		for(int i = 1 ; i < raw.length ; i++){
			String line[] = split(raw[i],'\t');
			//println(line);

			for(int ii = 0 ; ii < line.length;ii++){
				println("line["+ii+"] = "+line[ii]);
			}
			tmp.add(
					new Entry(
						x,y,i-1,
						line[0],
						line[1],
						line[2],
						line[3],
						line[4],
						line[5],
						line[6],
						line[7],
						line[8],
						line[9])
			       );

			x += W + 20;

			if (x > width/2-W){
				x=50;
				y+=H+20;
				maxH=max(H,maxH)+H+20;
			}
		};
		maxH = maxH+H+20 - height;
		return tmp;
	}
}

class Entry{

	String filename,autor,puvodni_nazev,anglicke_nazvy,rok,kdy,kdy_en,email,souhlas,statement;
	PImage thumb;
	PVector pos;
	int w, h;
	int id;
	boolean playing = false;
	String anotace;
	//fix this!
	String extension = "mp4";

	Entry(
			int _x,
			int _y,
			int _id,
			String _filename,
			String _autor,
			String _puvodni_nazev,
			String _anglicke_nazvy,
			String _rok,
			String _kdy,
			String _kdy_en,
			String _statement,
			String _email,
			String _souhlas
	     ){


		filename=_filename+"";

		autor=_autor+"";
		puvodni_nazev=_puvodni_nazev+"";
		anglicke_nazvy=_anglicke_nazvy+"";
		rok=_rok+"";
		kdy=_kdy+"";
		kdy_en=_kdy_en+"";
		email=_email+"";
		souhlas=_souhlas+"";
		statement=_statement+"";

		// println(_statement);
		statement = statement.replace("* ","\n");
		statement = statement.replace(" *","\n");
		statement = statement.replace("*","\n");


		id = _id;
		pos = new PVector(_x, _y);
		w = width/2;
		h = height-100;
		anotace = filename+" "+autor;

		if(filename.equals("")){
			thumb = loadImage("empty.png");
		}else if(createThumb()){
			thumb = loadImage(path+"thumbnails/"+filename+".png");
		}else{
			thumb = loadImage("empty.png");
		}
	}



	boolean createThumb() {
		try { 
			ProcessBuilder pb = new ProcessBuilder("/usr/bin/ffmpeg", "-ss", tc, "-i", path+"videos/"+filename, "-vframes", "1", "-vf", "scale="+W+":"+H, "-y", path+"thumbnails/"+filename+".png"," > /dev/null");
			Process proc = pb.start();

			try {
				proc.waitFor();
			}catch(Exception e) {
				return false;
			}

		}
		catch(Exception e) {
			return false;
		}
		return true;
	}

	void draw() {

		fill(0);
		noFill();
		image(thumb, pos.x, pos.y,W,H);

		if (over()) {
			pushStyle();
			stroke(0);
			strokeWeight(3);

			rect(pos.x, pos.y, W, H);

			popStyle();
			if (mousePressed) {
				run();
			}
		}
	}

	void run() {
		if (!playing) {
			println("running "+id+" filename "+filename);

			int http = statement.indexOf("http");
			if(http > -1 ){
				String address = statement.substring(http,statement.length());
				if(address.indexOf(" ")>-1){
					address = ""+address.substring(0,address.indexOf(" "));
				}
				println("opening "+address);
				//link(address);
				try{

					ProcessBuilder pb = new ProcessBuilder("firefox",address);
					Process proc = pb.start();
					proc.waitFor();
					playing = false;
				}catch(Exception e){

				}
			}else{
				// fix correct process handling
				try {
					if(!filename.equals("") && !playing){

						ProcessBuilder pb = new ProcessBuilder("mpv", "--fs", "--osc=no", path+"videos/"+filename, " > /dev/null "," 2>&1");

						pb.redirectErrorStream(true);


						//Process proc = Process.start(new String[]{});
						Process proc = pb.start();
						InputStreamReader isr = new InputStreamReader(proc.getInputStream());
						BufferedReader br = new BufferedReader(isr);	
						String line = null;
						while ((line = br.readLine()) != null) {               
							System.out.println(line);
						}


						try{
							proc.waitFor();
							playing=false;
						}catch(Exception e){;}
					}
					playing = false;
				}
				catch(Exception e) {
					playing = false;
					println(e);
				}
			}

			playing=true;
		}
	}

	int numLines(String input){
		int c = 0;

		if(input.indexOf('\n')==-1)
			return 0;

		while(input.indexOf('\n')>-1){
			input=input.substring(input.indexOf('\n')+1,input.length());
			c++;
		}
		return c;
	}

	void drawText(){
		int pad = 20;

		textFont(header);
		int hh = pad*10;
		text(autor+"\n"+puvodni_nazev+"\n"+((anglicke_nazvy.length()>1)?anglicke_nazvy+"\n":"")+rok, width/2+pad,hh,width/2-pad*2,height-pad*2);

		hh+=numLines(autor+"\n"+puvodni_nazev+"\n"+rok)*72+50;

		textFont(body);

		/*
		   if(!filename.equals("")){
		   hh+=pad*4;
		   text("filename:\n"+filename+".mp4",width/2+pad,hh,width/2-pad*8,height-pad*2);
		   }
		 */

		if(!kdy.equals("")){
			hh+=pad*4;
			text(kdy,width/2+pad,hh,width/2-pad*8,height-pad*2);
		}

		if(!kdy_en.equals("")){
			hh+=pad*4;
			text(kdy_en,width/2+pad,hh,width/2-pad*8,height-pad*2);
		}


		/*
		   if(!souhlas.equals("")){
		   hh+=pad*4;
		   text("agreement:\n"+souhlas,width/2+pad,hh,width/2-pad*8,height-pad*2);
		   }

		   if(!email.equals("")){
		   hh+=pad*4;
		   text("contact:\n"+email,width/2+pad,hh,width/2-pad*8,height-pad*2);
		   }
		 */

		if(!statement.equals("")){
			hh+=pad*4;
			text(statement,width/2+pad,hh,width/2-pad*8,height-pad*2);
		}

	}

	boolean over() {
		if (mouseX>pos.x && mouseX<W+pos.x && mouseY>pos.y-scroll && mouseY<H+pos.y-scroll){
			lover = id;
			return true;
		}else{
			return false;
		}
	}
}


//scroll

void mouseWheel(MouseEvent event) {
	float e = event.getCount();
	scrollTarget += (e*H/2+20);
	//println(e);
}
