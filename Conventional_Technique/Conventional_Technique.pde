import gab.opencv.*;
import processing.video.*;
import java.awt.*;

PImage background, superman, wall, homescreen;
int score, highscore, x, y, supermanJumpHeight, wallx[] = new int[2], wally[] = new int[2];
boolean isGameOver;

void setup() {
  background =loadImage("bg.png");
  superman =loadImage("superman.png");
  wall =loadImage("wall.png");
  homescreen=loadImage("welcome.png");
  
  isGameOver = true; 
  score = 0; highscore = 0; x = -200; supermanJumpHeight = 0; 
  
  size(600,800);
  fill(0,0,0);
  textSize(20);  
}

void draw() { 
  if(isGameOver == false) {
    
    imageMode(CORNER);
    image(background, x, 0);
    image(background, x+background.width, 0);
    
    x -= 1;
    supermanJumpHeight += 1;
    y += supermanJumpHeight;
    
    if(x == -1920){
      x = 0;
    }
    
    for(int i = 0 ; i < 2; i++) {
      imageMode(CENTER);
      image(wall, wallx[i], wally[i] - (wall.height/2+100));
      image(wall, wallx[i], wally[i] + (wall.height/2+100));
      
      if(wallx[i] < 0) {
        wally[i] = (int)random(200,height-200);
        wallx[i] = width;
      }
      
      if(wallx[i] == width/2){
        highscore = max(++score, highscore);
      }
      
      if(y>height||y<0||(abs(width/2-wallx[i])<25 && abs(y-wally[i])>100)){
        isGameOver=true;
      }
      
      wallx[i] -= 2;
    }
    
    image(superman, width/2, y);
    text("Score: "+score, 10, 20);
  }
  else {
    imageMode(CENTER);
    image(homescreen, width/2,height/2);
    text("High Score: "+highscore, 50, 130);
  }
}

void keyPressed() {
  supermanJumpHeight = -13;
  
  if(isGameOver==true) {
    wallx[0] = 600;
    wally[0] = y = height/2;
    wallx[1] = 900;
    wally[1] = 600;
    x = score = 0;
    isGameOver = false;
  }
}

void mousePressed() {
  supermanJumpHeight = -13;
  
  if(isGameOver==true) {
    wallx[0] = 600;
    wally[0] = y = height/2;
    wallx[1] = 900;
    wally[1] = 600;
    x = score = 0;
    isGameOver = false;
  }
}
