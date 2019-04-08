

PImage logo;
ArrayList videos;

int W = 160;
int H = 120;

void setup() {
  //size(displayWidth, displayHeight, P2D);
  size(1024, 768, P2D);

  //println(display);
  logo = loadImage("logo.png");
  videos = new ArrayList();

  int x = 50, y = 50;
  for (int i = 0; i < 20; i++) {
    videos.add(new Thumbnail("test1.mov", x, y, i));
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

  Thumbnail(String _filename, int _x, int _y, int _id) {
    id = _id;
    filename=_filename+"";
    pos = new PVector(_x, _y);
    w = W;
    h = H;
    thumb = createImage(w, h, RGB);
  }

  void draw() {

    noFill();
    image(thumb, pos.x, pos.y);
    if (over()) {
      pushStyle();
      stroke(0);
      strokeWeight(3);

      rect(pos.x, pos.y, w, h);
      popStyle();
    }
  }

  boolean over() {
    if (mouseX>pos.x&&mouseX<w+pos.x&&mouseY>pos.y&&mouseY<h+pos.y)
      return true;
    else
      return false;
  }
}
