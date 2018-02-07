

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
float diameter=0;
float diameter2=0;
float angle =0;
float c1 =0;
Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Oscil  wave;
float kickSize, snareSize, hatSize;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup()
{
  size(1200, 1200, P3D);
frameRate(20);
smooth();
// frame.setResizable(true);
  minim = new Minim(this);
  
  song = minim.loadFile("devotion.mp3", 1024);
  song.play();
  song.loop();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate()*150);

  beat.setSensitivity(1000);  
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
    wave = new Oscil( 440, 0.5f, Waves.SINE );
}

void draw()
{
  background(0);
  // draw a green rectangle for every detect band
  // that had an onset this frame
  translate(width/2, height/2);
  for(int i = 0; i < beat.detectSize(); ++i)
  {
    // test one frequency band for an onset
    if ( beat.isOnset(i) )

    {
     for(int j = 0; j< song.bufferSize() - 1; j++)
  {
     beat.setSensitivity(j);

    pushMatrix();
      rotate(j*mouseX);
     drawFlower( j, i, i/10 );
      drawFlower( j, i/2, i/10);
      rotate(i*i*sin(i*mouseX));
      drawFlower( i, i, sin(song.right.get(i)));
    popMatrix();

  }
    }
  
  }
  
  // draw an orange rectangle over the bands in 
  // the range we are querying
  int lowBand = 15;
  int highBand = 15;
  // at least this many bands must have an onset 
  // for isRange to return true
  int numberOfOnsetsThreshold = 30;
  if ( beat.isRange(lowBand, highBand, numberOfOnsetsThreshold) )
  { 
  for(int i = 0; i < song.bufferSize() - 1; i++)
  {  
     translate(i,i);
     scale(i/10);
     beat.setSensitivity(i/5);
     translate(song.left.get(i), song.right.get(i));
    //float x1 = map( i, 0, song.bufferSize()+lowBand, 0, width );
    float x2 = map( i+1, 0, song.bufferSize()+highBand, 0, width/2 );
    rotate(i*mouseX);
    drawFlower(0,0,song.left.get(i/2));
  

  }
  }
  
  if ( beat.isKick() && !(beat.isHat()) &&  !(beat.isSnare())) {  
   for(int i = 0; i < song.bufferSize() - 1; i+=5){
     translate(song.left.get(i),i/2);
    beat.setSensitivity(i);
    scale(i/25);
   rotate(0.05);
   drawFlower(i/2,i/2, i/2);
   point(sin(song.left.get(i)),cos(song.right.get(i)),10);

  }
  }
  if ( beat.isSnare() && !(beat.isKick()) && !(beat.isHat())) {
     for(int i = 0; i < song.bufferSize() - 1; i+=10){
   float x1 = map( i, 0, beat.detectSize(), 0, width/beat.detectSize() );
    float x2 = map( i+10, 0,beat.detectSize(), 0, height/song.left.get(beat.detectSize()) );
   pushMatrix();
    scale(i/50);
  beat.setSensitivity(i/150);
  rotate(i*mouseX);
  drawFlower(i,-i,tan(i));
  popMatrix();
  }
  
  }
  if ( beat.isHat() && !(beat.isKick()) && !(beat.isSnare())) {
      for(int i = 0; i < song.bufferSize() -1; i+=20){
   float x1 = map( i, 0, beat.detectSize(), i, width/beat.detectSize()/10 ); 
  pushMatrix();
  scale(i/100);
  beat.setSensitivity(i/100);
  rotate(i*mouseX/2);
  drawFlower(-i,i,i+cos(i));

 popMatrix();
  }
  if(beat.isHat() && beat.isKick()){
    for( int i = 0; i < song.bufferSize() - 1; i += 20){
   pushMatrix();
   scale(i/150);
  beat.setSensitivity(i);
  drawFlower(sin(i/150),tan(i/150),i);
   popMatrix();
 
    }
  }
    if(beat.isHat() && beat.isSnare()){
 for( int i = 0; i < song.bufferSize() - 1; i += 40){
   scale(i/200);
  beat.setSensitivity(i/200);
  pushMatrix();
  rotate(sin(i*mouseX));
  drawFlower(cos(-i),atan(-i),i);
  rotate(i/150*mouseX);
  float r = radians(i);
  drawFlower(i*tan(r),-i+mouseX,i);
  popMatrix();
  
    }  
    }
  }

  saveFrame("GA-######.png");
    
  }
  

  

void drawFlower(float x, float y,float radius){


 diameter = 10;
 radius = radius/20+ (sin(angle) * diameter/2) + diameter/2;
 scale(radius/15);
colorMode(HSB);
  color c2  = color(map(x, 0, width, 0,255), 255, 255,150);
  fill(c2);

 noStroke();
  color c  = color(map(x, 0, width, 0,255), 255, 255,200+radius);
 stroke(c);
  strokeWeight(1.6);
  rotate(mouseX/10);
  lights();
  box(10);
  ellipse(0,0,radius/2,radius/2);
 ellipse(x,y,radius,radius);
 ellipse(x,y,angle/100,angle/100);
  strokeWeight(0.5);
  line(x,y,angle/2,angle/2);
  angle += 0.001;
 }
 