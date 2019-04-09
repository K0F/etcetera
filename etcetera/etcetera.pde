

PImage logo;
ArrayList videos;
String filenames[];

int W = 160;
int H = 120;

void setup() {
  //size(displayWidth, displayHeight, P2D);
  size(1024, 768, P2D);


  filenames = getFiles("/home/kof/src/etcetera/etcetera/videos");
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
    thumb = createImage(w, h, RGB);
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
      playing = true;
      // fix correct process handling
      exec(new String[]{"#!/bin/bash", "mpv /home/kof/etcetera/etcetera/videos/"+filename});
    }
  }

  boolean over() {
    if (mouseX>pos.x&&mouseX<w+pos.x&&mouseY>pos.y&&mouseY<h+pos.y)
      return true;
    else
      return false;
  }
}
