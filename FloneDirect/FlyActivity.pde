void drawFlyActivity() {
  lineY = (int) map(rcThrottle, 1000, 2000, maxlineY-20, minlineY+20);

  strokeWeight(15);
  stroke(255, 0, 0);
  line(0, lineY, width, lineY);
  strokeWeight(1);
  stroke(255, 255, 255, 255);

  fill(0, 0, 100, 100);
  rectMode(CENTER);
  rect((width/2), (height/2), width-(padding*2), width-(padding*2), 10);

  fill(200, 0, 0, 100);
  ellipse( (width/2), (height/2), width-(padding*4), width-(padding*4));
  for (int i=2;i<7;i++) {
    ellipse( (width/2), (height/2), (width/i), (width/i));
  }

  posY = (int) map(rcRoll, minRC, maxRC, height, 0);
  posX = (int) map(rcPitch, minRC, maxRC, width,0);
  
  fill(128);
  image(floneImg, width-posX, posY);

  //Update Sliders    
  rcStickThrottleSlider.setValue(rcThrottle);
  rcStickRollSlider.setValue(rcRoll);
  rcStickPitchSlider.setValue(rcPitch);
  rcStickYawSlider.setValue(rcYaw);
  rcStickAUX1Slider.setValue(rcAUX1);
  rcStickAUX2Slider.setValue(rcAUX2);

  a=radians(angx);
  if (angy<-90) b=radians(-180 - angy);
  else if (angy>90) b=radians(+180 - angy);
  else b=radians(angy);
  h=radians(head);

  drawPitchRoll();
  drawFlyLevel();
  drawCompass();
    
  //stroke(255);
  text(int(frameRate) + " fps", padding,  ((height/2) + (width/2))+doublePadding);
  
  cycle = millis() - lastCycle;
  text("Cycle: " + int(cycle) + " ms", width-padding-200, ((height/2)+(width/2))+doublePadding);
  lastCycle = millis();  
  
  text("Acc: " + int(cycleAcc) + " ms" , (width/2)-200, ((height/2)+(width/2))+doublePadding);
  text("Mag: " + int(cycleMag) + " ms", (width/2), ((height/2)+(width/2))+doublePadding);
}

// ---------------------------------------------------------------------------------------------
// Fly Level Control Instruments
// ---------------------------------------------------------------------------------------------
void drawPitchRoll() {

  pushMatrix();
  translate(xLevelObj-(levelBallSize/2)-4, yLevelObj+(levelBallSize)+40);
  fill(50, 50, 50);
  noStroke();
  ellipse(0, 0, levelBallSize, levelBallSize);
  rotate(a);
  fill(255, 255, 127);
  //textFont(font12);
  text("ROLL", -13, 15);
  strokeWeight(1.5);
  stroke(127, 127, 127);
  line(-30, 1, 30, 1);
  stroke(255, 255, 255);
  line(-30, 0, +30, 0);
  line(0, 0, 0, -10);
  popMatrix();

  pushMatrix();
  translate(xLevelObj+(levelBallSize/2)+4, yLevelObj+(levelBallSize)+40);
  fill(50, 50, 50);
  noStroke();
  ellipse(0, 0, levelBallSize, levelBallSize);
  rotate(b);
  fill(255, 255, 127);
  //textFont(font12);
  text("PITCH", -18, 15);
  strokeWeight(1.5);
  stroke(127, 127, 127);
  line(-30, 1, 30, 1);
  stroke(255, 255, 255);
  line(-30, 0, 30, 0);
  line(30, 0, 30-size/6, size/6);
  line(+30, 0, 30-size/6, -size/6);  
  popMatrix();

  // info angles
  fill(255, 255, 127);
  // textFont(font12);
  text((int)angy + "°", xLevelObj+(levelBallSize/2), yLevelObj+padding); //pitch
  text((int)angx + "°", xLevelObj-(levelBallSize/2), yLevelObj+padding); //roll
}

  // ---------------------------------------------------------------------------------------------
  // Magnetron Combi Fly Level Control
  // ---------------------------------------------------------------------------------------------

void drawFlyLevel(){
  //horizonInstrSize=100;//68
  
  angyLevelControl=((angy<-horizonInstrSize) ? -horizonInstrSize : (angy>horizonInstrSize) ? horizonInstrSize : angy);
  pushMatrix();
  translate(xLevelObj,yLevelObj);
  noStroke();
  // instrument background
  fill(50,50,50);
//  ellipse(0,0,150,150);
ellipse(0,0,200,200);

  // full instrument
  rotate(-a);
  rectMode(CORNER);
  // outer border
  strokeWeight(1);
  stroke(90,90,90);
  //border ext
//  arc(0,0,140,140,0,TWO_PI);
  arc(0,0,levelSize,levelSize,0,TWO_PI);
  
  stroke(190,190,190);
  //border int
  //arc(0,0,138,138,0,TWO_PI);
  arc(0,0,levelSize-2,levelSize-2,0,TWO_PI);
  // inner quadrant
  strokeWeight(1);
  stroke(255,255,255);
  fill(124,73,31);
  //earth
  //float 
  angle = acos(angyLevelControl/horizonInstrSize);
  //arc(0,0,136,136,0,TWO_PI);
  arc(0,0,levelSize-6,levelSize-6,0,TWO_PI);
  fill(38,139,224); 
  //sky 
  //arc(0,0,136,136,HALF_PI-angle+PI,HALF_PI+angle+PI);
  arc(0,0,levelSize-6,levelSize-6,HALF_PI-angle+PI,HALF_PI+angle+PI);
  //float 
  x = sin(angle)*horizonInstrSize;
  if (angy>0) 
    fill(124,73,31);
  noStroke();   
  triangle(0,0,x,-angyLevelControl,-x,-angyLevelControl);
  // inner lines
  strokeWeight(1);
  for(i=0;i<8;i++) {
    j=i*15;
    if (angy<=(35-j) && angy>=(-65-j)) {
      stroke(255,255,255); line(-30,-15-j-angy,30,-15-j-angy); // up line
      fill(255,255,255);
      //textFont(font9);
      text("+" + (i+1) + "0", 34, -12-j-angy); //  up value 34
      text("+" + (i+1) + "0", -68, -12-j-angy); //  up value
    }
    if (angy<=(42-j) && angy>=(-58-j)) {
      stroke(167,167,167); line(-20,-7-j-angy,20,-7-j-angy); // up semi-line
    }
    if (angy<=(65+j) && angy>=(-35+j)) {
      stroke(255,255,255); line(-30,15+j-angy,30,15+j-angy); // down line
      fill(255,255,255);
      //textFont(font9);
      text("-" + (i+1) + "0", 34, 17+j-angy); //  down value
      text("-" + (i+1) + "0", -68, 17+j-angy); //  down value
    }
    if (angy<=(58+j) && angy>=(-42+j)) {
      stroke(127,127,127); line(-20,7+j-angy,20,7+j-angy); // down semi-line
    }
  }
  strokeWeight(2);
  stroke(255,255,255);
  if (angy<=50 && angy>=-50) {
    line(-40,-angy,40,-angy); //center line
    fill(255,255,255);
    //textFont(font9);
    text("0", 34, 4-angy); // center
    text("0", -39, 4-angy); // center
  }

  // lateral arrows
  strokeWeight(1);
  // down fixed triangle
  stroke(60,60,60);
  fill(180,180,180,255);

  triangle(-horizonInstrSize,-8,-horizonInstrSize,8,-55,0);
  triangle(horizonInstrSize,-8,horizonInstrSize,8,55,0);

  // center
  strokeWeight(1);
  stroke(255,0,0);
  line(-20,0,-5,0); line(-5,0,-5,5);
  line(5,0,20,0); line(5,0,5,5);
  line(0,-5,0,5);
  popMatrix();
}
 

void drawCompass(){
  // ---------------------------------------------------------------------------------------------
  // Compass Section
  // ---------------------------------------------------------------------------------------------
  pushMatrix();
  translate(xCompass,yCompass);
  // Compass Background
  fill(0, 0, 0);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  //size=48;
  //rect(-size*2.5,-size*2.5,size*2.5,size*2.5);
  // GPS quadrant
  strokeWeight(1.5);
  if (GPS_update == 1) {
    fill(125);stroke(125);
  } else {
    fill(160);stroke(160);
  }
  ellipse(0,  0,   4*size+7, 4*size+7);
  // GPS rotating pointer
  rotate(GPS_directionToHome*PI/180);
  strokeWeight(4);stroke(255,255,100);line(0,0, 0,-2.4*size);line(0,-2.4*size, -5 ,-2.4*size+10); line(0,-2.4*size, +5 ,-2.4*size+10);  
  rotate(-GPS_directionToHome*PI/180);
  // compass quadrant
  strokeWeight(1.5);fill(0);stroke(0);
  ellipse(0,  0,   2.6*size+7, 2.6*size+7);
  // Compass rotating pointer
  stroke(255);
  rotate(head*PI/180);
  line(0,size*0.2, 0,-size*1.3); line(0,-size*1.3, -5 ,-size*1.3+10); line(0,-size*1.3, +5 ,-size*1.3+10);
  popMatrix();
  // angles 
  for (i=0;i<=12;i++) {
    angCalc=i*PI/6;
    if (i%3!=0) {
      stroke(75);
      line(xCompass+cos(angCalc)*size*2,yCompass+sin(angCalc)*size*2,xCompass+cos(angCalc)*size*1.6,yCompass+sin(angCalc)*size*1.6);
    } else {
      stroke(255);
      line(xCompass+cos(angCalc)*size*2.2,yCompass+sin(angCalc)*size*2.2,xCompass+cos(angCalc)*size*1.9,yCompass+sin(angCalc)*size*1.9);
    }
  }
//  textFont(font15);
  text("N", xCompass-5, yCompass-22-size*0.9);text("S", xCompass-5, yCompass+32+size*0.9);
  text("W", xCompass-33-size*0.9, yCompass+6);text("E", xCompass+21+size*0.9, yCompass+6);
  // head indicator
//  textFont(font12);
  noStroke();
  fill(80,80,80,130);
  rect(xCompass-22,yCompass-8,xCompass+22,yCompass+9);
  fill(255,255,127);
  text(head + "°",xCompass-11-(head>=10.0 ? (head>=100.0 ? 6 : 3) : 0),yCompass+6);
  // GPS direction indicator
  fill(255,255,0);
  text(GPS_directionToHome + "°",xCompass-6-size*2.1,yCompass+7+size*2);
  // GPS fix
  if (GPS_fix==0) {
     fill(127,0,0);
  } else {
     fill(0,255,0);
  }
  //ellipse(xCompass+3+size*2.1,yCompass+3+size*2,12,12);
  rect(xCompass-28+size*2.1,yCompass+1+size*2,xCompass+9+size*2.1,yCompass+13+size*2);
//  textFont(font9);
  if (GPS_fix==0) {
    fill(255,255,0);
  } else {
    fill(0,50,0);
  }
  text("GPS_fix",xCompass-27+size*2.1,yCompass+10+size*2);
}

