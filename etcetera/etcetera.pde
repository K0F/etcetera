

PImage logo;
ArrayList videos;
String filenames[];
String path = "/home/kof/src/etcetera/etcetera/videos/";

int W = 160;
int H = 120;

void setup() {
  //size(displayWidth, displayHeight, P2D);
  size(1024, 768, P2D);


  filenames = getFiles(path);
  println(filenames);

  textFont(loadFont("MonacoForPowerline-10.vlw"));

  //println(display);
  logo = loadImage("logo.png");
  videos = new ArrayList();

  int x = 50, y = 50;
  for (int i = 0; i < filenames.length; i++) {
    videos.add(new Thumbnail(filenames[i], x, y, i));
    x += W + 20;
    if (x>width-W-100) {
      x=50;
      y+=H+20;
    }
  }
}



void draw() {
  background(255);
  image(logo, width-logo.width-40, 20);

  for (int i = 0; i < videos.size(); i++) {
    Thumbnail tmp = (Thumbnail)videos.get(i);
    tmp.draw();
  }
}

class Thumbnail {
  PImage thumb;
  PVector pos;
  String filename;
  int w, h;
  int id;
  boolean playing = false;

  Thumbnail(String _filename, int _x, int _y, int _id) {
    id = _id;
    filename=_filename+"";
    pos = new PVector(_x, _y);
    w = W;
    h = H;
    createThumb();
    thumb = createImage(w, h, RGB);
  }
  
  void createThumb(){
    try{ 
    ProcessBuilder pb = new ProcessBuilder("/usr/bin/ffmpeg", " -ss 00:01:27"," -i "+path+""+filename," -vframes 1"," -y /home/kof/thumbnail.png > /tmp/err 2>&1");
    
    Process proc = pb.start();
    
  }catch(Exception e){
     ; 
    }
  }

  void draw() {

    fill(0);
    text(filename, pos.x, pos.y+h+10, w, 20);
    noFill();
    image(thumb, pos.x, pos.y);

    if (over()) {
      pushStyle();
      stroke(0);
      strokeWeight(3);

      rect(pos.x, pos.y, w, h);

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
        ProcessBuilder pb = new ProcessBuilder("/usr/bin/mpv", "--fs", "/home/kof/src/etcetera/etcetera/videos/"+filename, " > /dev/null");
        //Process proc = Process.start(new String[]{});
        Process proc = pb.start();
        playing = true;
      }
      catch(Exception e) {
        println(e);
      }
    }
  }

  boolean over() {
    if (mouseX>pos.x && mouseX<w+pos.x && mouseY>pos.y && mouseY<h+pos.y)
      return true;
    else
      return false;
  }
}
