import java.util.Map;

/* 

  ** VIDEO AND AUDIO TRANSCRIPTOR **
  
  AUTHOR:  PANOS MAVROS, 2016, FUTURE CITIES LABORATORY

*/

/* 

STEPS
1. READ VIDEO SOURCE = DRAG AND DROP
2. EXTRACT START TIME AND FRAME RATE
3. PLAYBACK
4. BUTTONS TO ANNOTATE
5. BUTTON BEHAVIOUR ADDS TIMESTAMPS TO CSV file
6. TRANSCRIBE TEXT IN FORM. SAVE ON THE FLY to avoid data loss.
*/

// LIBRARIES

import controlP5.*;
import drop.*;
import processing.video.*;
import java.nio.file.*;
import java.nio.file.Files;
import java.nio.file.attribute.*;
import java.nio.file.attribute.FileTime;
import java.nio.file.attribute.BasicFileAttributes;

Movie myMovie;
Movie mov;
SDrop drop;
ControlP5 cp5;
String movieFile;

// GLOBAL VARIABLES
int newFrame;
boolean paused = false;
int myColor = color(255);
int c1,c2;
float n,n1;
FileTime creationTime;
int currentFrame=0;
float frameSize = 0;

void setup (){
  
    size(640, 640);
    drop = new SDrop(this);
 
    background(0);
    cp5 = new ControlP5(this);
    uiSetup();
    selectInput("Select a file to process:", "fileSelected");

    if(mov != null){
      
    mov = new Movie(this, movieFile);

    // Pausing the video at the first frame. 
    mov.play();
    mov.jump(0);
    mov.pause();
    }

}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    //println("User selected " + selection.getAbsolutePath());
    if(selection.isFile()) {
      Path path = Paths.get(selection.getAbsolutePath());
      BasicFileAttributes attr;
      try {
         attr = Files.readAttributes(path, BasicFileAttributes.class);
         System.out.println("Creation time: " + attr.creationTime());     
         creationTime = attr.creationTime();
         
       
     
    } catch (IOException e) {
     System.out.println("oops un error! " + e.getMessage());
    }
      
    movieFile = selection.getAbsolutePath();
    mov = new Movie(this, movieFile);
    
     frameSize = width/mov.duration();
     print( frameSize );
     
    println(getLength()+" "+ mov.duration() +" "+mov.time());
    
    // float md = mov.duration();
  //oat mt = mov.time();

    // Pausing the video at the first frame. 
    mov.play();
    mov.jump(0);
    mov.pause();
      
    }
   
  }
  
 
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  background(0);
  if(mov != null){
 
  image(mov, 0, 50, width, 50+width/2);
  
  fill(255);
  text(getFrame() + " / " + (getLength() - 1), 10, 30);
  
  
  if(getLength()>0){
    fill(255, 0, 0 );
    noStroke();
    rectMode(CORNERS);
    rect(0,40, mov.time()*(width/mov.duration()), 50);
  }

   //FileTime FrameTime =  from(
   //creationTime.toMillis() + getFrame());
  int currentFrameTime = getFrame();
  text(creationTime.toMillis() + getFrame()+" / ", 100, 30);
  
  if(paused){
    mov.pause();
  } else {
    mov.play();
  }
  }
}

void keyPressed() {
   println(key);
   
   if (key == 'p') {
      if(paused){
        paused = false;
      } else {
        paused = true;
      }
    }
    
  if (key == CODED) {
    
    if (keyCode == LEFT) {
      if (0 < newFrame) newFrame = getFrame()-1; 
    } else if (keyCode == RIGHT) {
      if (newFrame < getLength() - 1) newFrame= getFrame()+1;
    }
    
      setFrame(newFrame);  

  } 
  
  
}
  
int getFrame() {    
  return ceil(mov.time() * 30) - 1;
}

void setFrame(int n) {
  mov.play();
    
  // The duration of a single frame:
  float frameDuration = 1.0 / mov.frameRate;
    
  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 
    
  // Taking into account border effects:
  float diff = mov.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }
    
  mov.jump(where);
  mov.play();
  //mov.pause();  
}  

int getLength() {
  return int(mov.duration() * mov.frameRate);
}



public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  n = 0;
  
  if (theEvent.getController().getName().equals("Route A")) {
       println(getLength()+" "+ mov.duration() +" "+mov.time());
    }
}