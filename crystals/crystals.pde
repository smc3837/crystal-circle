int numCry = 8;
Crystal[] cryArray = new Crystal[numCry];

void setup(){
  size(1000, 1000, P3D);
  colorMode(HSB, 360, 100, 100);
  for(int i=0; i< numCry; i++){
    Crystal temp = new Crystal(random(75,100),random(3,5));
    cryArray[i] = temp;
  }
  smooth(8);
  frameRate(60);
}

void draw(){
  background(0);
  stroke(180,100,100);
  
  
  translate(width/2, height/2);
  rotateX(radians(180));
  rotateX(radians(-30+(sin(radians(frameCount))*15)));
  
  //rotateY(radians(frameCount*0.5));
  
  /*pushStyle();
  strokeWeight(1);
  stroke(0,100,100);
  line(0,0,0,1000,0,0);
  stroke(20,100,100);
  line(0,0,0,-1000,0,0);
  
  stroke(120,100,100);
  line(0,0,0,0,1000,0);
  stroke(100,100,100);
  line(0,0,0,0,-1000,0);
  
  stroke(240,100,100);
  line(0,0,0,0,0,1000);
  stroke(240,100,100);
  line(0,0,0,0,0,-1000);
  popStyle();*/

  fill(0);
  //noFill();
  
  for (int j=0; j< numCry; j++){
    pushMatrix();
    rotateY(radians((360/numCry)*j));
    rotateY(radians(frameCount));
    translate(0,-150-sin(radians(frameCount))*50,250);
    if(j%2==0){
      translate(0,(+sin(radians(frameCount))*50)+(-cos(radians(frameCount))*50),0);
    }
    cryArray[j].update();
    popMatrix();
  }
  
  String count = String.format("%06d", frameCount);
  //saveFrame("frames/"+count+".tif");
}

PVector polarToCart(float r, float theta){
  theta = radians(theta);
  float x = r * cos(theta);
  float y = r * sin(theta);
  PVector temp = new PVector(x, y);
  return temp;
}


class Crystal{
  int numSides = floor(random(3,7));
  float side;
  
  float totalLength;
  
  int numberOfPVectorsNeeded = numSides*2;
  PVector[] points = new PVector[numberOfPVectorsNeeded];
  
  PVector bottomPt;
  PVector topPt;
  
  //constructor
  Crystal(float sideLength, float totalLength){
    side = sideLength;
    
    totalLength = max(3, totalLength);
   
    //calc points for reg shapes
    for(int i = 0; i < numberOfPVectorsNeeded; i+=2){ 
      float angleStep = 360/numSides; //120
      float radius = side/2; //50
      
      int currentPoint = i; //2
      int topPoint = currentPoint+1; //3
      
      float currentTheta = angleStep * (i/2); //120
      float topTheta = currentTheta + (angleStep/2); //120 + 60 = 180
      
      PVector cP = polarToCart(radius, currentTheta);
      PVector tP = polarToCart(radius, topTheta);
      float bottomY = side;
      float topY = side*(totalLength-1); 
      
      points[currentPoint] = new PVector(cP.x, bottomY, cP.y);
      points[topPoint] = new PVector(tP.x, topY, tP.y);
    }
    
    //some geometry/trig bullshit
    //finding the length of a side in the polygon base
    float chord = side*sin(radians((360/numSides)/2))/2;
    
    
    //sets top and bottom points
    bottomPt = new PVector(0,side-chord,0);
    topPt = new PVector(0, side*totalLength - (side-chord), 0);
  }//end constructor
    
  void update(){
    //draw sides
    beginShape(TRIANGLE_STRIP);
    for(int j = 0; j< (numberOfPVectorsNeeded+2); j++){
      PVector pt = points[j % numberOfPVectorsNeeded];
      vertex(pt.x, pt.y, pt.z);
    }
    endShape();
    
    //top
    for(int k = 0; k < numberOfPVectorsNeeded; k++){
      beginShape(TRIANGLE);
      PVector cP = points[k];
      PVector nP = points[(k+2)%numberOfPVectorsNeeded];
      if (k%2 == 1){
        vertex(cP.x, cP.y, cP.z);
        vertex(topPt.x, topPt.y, topPt.z);
        vertex(nP.x, nP.y, nP.z);
      }
      else{
        vertex(cP.x, cP.y, cP.z);
        vertex(bottomPt.x, bottomPt.y, bottomPt.z);
        vertex(nP.x, nP.y, nP.z);
      }
      endShape();
    }
  }

}
