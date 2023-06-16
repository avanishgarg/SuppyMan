import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

int loadingScreenCounter=0;
boolean didUserChooseMovementDetectorType = false;
int userChoiseForMovementDetectorType = 0;

PImage background, superman, wall, homescreen;
boolean isWindowCreated = false;
int score, highscore, x, y, supermanJumpHeight, wallx[] = new int[2], wally[] = new int[2];
boolean isGameOver;

void setup() {
  background =loadImage("bg.png");
  superman =loadImage("superman.png");
  wall =loadImage("wall.png");
  homescreen=loadImage("welcome.png");
  score = 0; highscore = 0; x = -200; supermanJumpHeight = 0; 
  isGameOver=true;
  size(600,800);
  fill(0,0,0);
  textSize(20);   
}

void draw() { 

  surface.setLocation(660,50);
  
   if(didUserChooseMovementDetectorType==false){    
    textSize(25);
    fill(0,0,127);        
  }
  
  if ((userChoiseForMovementDetectorType == 1 || userChoiseForMovementDetectorType == 2) && didUserChooseMovementDetectorType == false) { 
    String[] args = {"TwoFrameTest"};
    HandMovementDetector sa = new HandMovementDetector();
    PApplet.runSketch(args, sa);
    didUserChooseMovementDetectorType=true;    
  }
  
  if(isGameOver == false && isWindowCreated==true && didUserChooseMovementDetectorType == true) {  
    imageMode(CORNER);
    image(background, x, 0);
    image(background, x+background.width, 0);
    x -= 1;
    //supermanJumpHeight += 1;
    //y += supermanJumpHeight;
    if(x == -1800) x = 0;
    for(int i = 0 ; i < 2; i++) {
      imageMode(CENTER);
      image(wall, wallx[i], wally[i] - (wall.height/2+150));
      image(wall, wallx[i], wally[i] + (wall.height/2+150));
      if(wallx[i] < 0) {
        wally[i] = (int)random(200,height-200);
        wallx[i] = width;
      }
      if(wallx[i] == width/2) highscore = max(++score, highscore);
      if(y>height||y<0||(abs(width/2-wallx[i])<37.5 && abs(y-wally[i])>125)) isGameOver=true;
      wallx[i] -= 2;
    }
    image(superman, width/2, y);
    text("Score: "+score, 10, 20);
  }
  else {
    imageMode(CENTER);
    image(homescreen, width/2,height/2);
    text("High Score: "+highscore, 25, 130);
    text("Enter 1 for Fist Movement Detector",25, 40); 
    text("Enter 2 for Head Movement Detector",25,65);
  }
}


void keyPressed() {
  
  if(isGameOver==true) {
    wallx[0] = 600;
    wally[0] = y = height/2;
    wallx[1] = 900;
    wally[1] = 600;
    x = score = 0;
    isGameOver = false;
  }
  
  if(didUserChooseMovementDetectorType==false && key == '1')  {   
    userChoiseForMovementDetectorType=1;    
  }
  else if(didUserChooseMovementDetectorType==false && key == '2')  {   
    userChoiseForMovementDetectorType=2;    
  }
  
}

void mousePressed() {
  
  if(isGameOver==true) {
    wallx[0] = 600;
    wally[0] = y = height/2;
    wallx[1] = 900;
    wally[1] = 600;
    x = score = 0;
    isGameOver = false;
  }
}

public class HandMovementDetector extends PApplet {

  Capture video;
  OpenCV opencv;
  
  boolean handDetectionPositive = false;  

  public void settings() {
    size(640, 480);
  }

  void setup() {     
    video = new Capture(this, 640/2, 480/2);
    opencv = new OpenCV(this, 640/2, 480/2);
    if(userChoiseForMovementDetectorType == 1)
      opencv.loadCascade(".\\fist.xml");    
    else if(userChoiseForMovementDetectorType == 2)      
     opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);    
    video.start();
  }

  void draw() {
    isWindowCreated = true;
    surface.setLocation(0,50);
    scale(2);
    opencv.loadImage(video);  
    image(video, 0, 0 );  
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    Rectangle[] faces = opencv.detect();
    
    if (userChoiseForMovementDetectorType == 2){
      for (int i = 0; i < faces.length; i++) {
    int area = faces[i].width*faces[i].height;
    println(faces[i].x + "," + faces[i].y + "," +area);
    
    
    if (area > 5500 && area < 8000)
    {
      textSize(20);
      text("Flying Straight", 100, 20);
      stroke(0, 255, 0);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    else if (area < 5500){
      textSize(20);
      text("Flying Down", 100, 20);
      y+=6;
      stroke(255, 0, 0);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    else{
      textSize(20);
      text("Flying Up", 100, 20);
      y-=6;
      stroke(0, 0, 255);
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }      
  }
    }
    else if (userChoiseForMovementDetectorType == 1){
      for (int i = 0; i < faces.length; i++) {
  
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      

      if(faces[i].x>0 && (faces[i].x+faces[i].width)<=320 && faces[i].y<=50) {               
        textSize(20);
        text("Flying Up", 100, 20);
        stroke(0, 0, 255);
        y-=6;
      }    
      else if(faces[i].x>0 && (faces[i].x+faces[i].width)<=320 && faces[i].y+faces[i].height>175) {   
        textSize(20);
        text("Flying Down", 100, 20);
        stroke(255, 0, 0);
        y+=6;
      }    
      else {       
        textSize(20);
        text("Flying Straight", 100, 20);
      }
    }
    line(0, 50, 320, 50);
    line(0, 175, 320, 175);
    }
  
  }
  void captureEvent(Capture c) {
    c.read();
  }
}
