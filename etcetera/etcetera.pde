
PImage logo;
Parser parser;
ArrayList entries;

String filenames[];
String path;

int W = 192;
int H = 108;
String tc = "00:00:37";

int lover = 0;
String text[];
PFont header,body;

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
    
    tmp.draw();

    if(lover==i)
      tmp.drawText();
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
      println(line.length);
      tmp.add(
      new Entry(
            x,y,i,
            line[0],
            line[1],
            line[2],
            line[3],
            line[4],
            line[5],
            line[6],
            line[7],
            line[8])
            );

            x += W + 20;
            
            if (x > width/2-W){
              x=50;
              y+=H+20;
            }
    };
    return tmp;
  }
}

class Entry{

  String filename,autor,puvodni_nazev,anglicke_nazvy,rok,kdy,email,souhlas,statement;
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
      String _email,
      String _souhlas,
      String _statement
      ){

    filename=_filename+"";

    autor=_autor+"";
    puvodni_nazev=_puvodni_nazev+"";
    anglicke_nazvy=_anglicke_nazvy+"";
    rok=_rok+"";
    kdy=_kdy+"";
    email=_email+"";
    souhlas=_souhlas+"";
    statement=_statement+"";

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
      ProcessBuilder pb = new ProcessBuilder("/usr/bin/ffmpeg", "-ss", tc, "-i", path+"videos/"+filename+"."+extension, "-vframes", "1", "-vf", "scale="+W+":"+H, "-y", path+"thumbnails/"+filename+".png");
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

      // fix correct process handling
      try {
        ProcessBuilder pb = new ProcessBuilder("/usr/bin/mpv", "--fs", "--osd-level", "0", path+"videos/"+filename, " > /dev/null");
        //Process proc = Process.start(new String[]{});
        Process proc = pb.start();
        playing = true;
        proc.waitFor();
        playing = false;
      }
      catch(Exception e) {
        println(e);
      }
    }
  }

  void drawText(){
    int pad = 20;

    textFont(header);
    text(autor+"\n"+puvodni_nazev+", "+rok, width/2+pad,pad,width/2-pad*2,height-pad*2);
    
    textFont(body);
    text(statement,width/2+pad,pad,width/2-pad*2,height-pad*2+300);
  }

  boolean over() {
    if (mouseX>pos.x && mouseX<W+pos.x && mouseY>pos.y && mouseY<H+pos.y){
      lover = id;
      return true;
    }else{
      return false;
    }
  }
}
