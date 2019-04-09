

PImage logo;
ArrayList videos;
String filenames[];
String path = "/home/kof/src/etcetera/etcetera/";

int W = 192;
int H = 108;
String tc = "00:03:37";

void setup() {
  //size(displayWidth, displayHeight, P2D);
  size(1024, 768, P2D);


  filenames = getFiles(path+"videos");
  println(filenames);

  textFont(loadFont("MonacoForPowerline-10.vlw"));

  //println(display);
  logo = loadImage("logo.png");
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
    try {
      thumb = loadImage(path+"/thumbnails/"+filename+".png");
    }
    catch(Exception e) {
      thumb = createImage(W, H, RGB);
    }
  }

  void createThumb() {
    try { 
      ProcessBuilder pb = new ProcessBuilder("/usr/bin/ffmpeg", "-ss", tc, "-i", path+"videos/"+filename, "-vframes", "1", "-vf", "scale="+W+":"+H, "-y", path+"thumbnails/"+filename+".png");
      Process proc = pb.start();
      try {
        proc.waitFor();
      }
      catch(Exception e) {
        ;
      }
    }
    catch(Exception e) {
      ;
    }
  }

  void draw() {

    fill(0);
    text(filename, pos.x, pos.y+h+6, w, 20);
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

  boolean over() {
    if (mouseX>pos.x && mouseX<w+pos.x && mouseY>pos.y && mouseY<h+pos.y)
      return true;
    else
      return false;
  }
}
