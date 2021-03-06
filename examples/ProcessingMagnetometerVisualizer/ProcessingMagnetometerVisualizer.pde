/*  Processing Code to draw circles from MPU-9250 data
* draws three circles that should overlap perfectly if data is
* properly offset and scaled.
* Use the Modern Device CalibrateMPU9250() sketch in your Arduino,
* Teensy, or clone.
* Notes:
* Serial at 57600 - set your Arduino sketch appropriately
* A float of value 1.11 is used as a header
* Arduino sketch needs to send this header
*/

import processing.serial.*;

float Xval = 0;        
float Yval = 0;      
float Zval = 0;       

int maxPoints = 20000;
int i;

float cVal;
Serial myPort;

void setup() {
    size(800, 800);
    background(0);
    noFill();
    stroke(255);
    strokeWeight(2);

    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // Change Serial.list()[3] '3' below to number of serial port you are using
    myPort = new Serial(this, Serial.list()[3], 57600);
    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');
    background(20);
    colorMode(HSB, 300);
    setupGrid();
}

void draw() {

    stroke(180);
    strokeWeight(2);


    stroke(55, 250, 300);
    point(Xval + width/2, Yval + height/2);
    stroke(130, 250, 300);
    point(Yval + width/2, Zval + height/2);
    stroke(280, 250, 300);
    point(Xval + width/2, Zval + height/2);
}

void serialEvent(Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');
    println(inString);
    if (inString != null) {
        // trim off any whitespace:
        // inString = trim(inString);
        println(inString);
        // split the string on the commas and convert the
        // resulting substrings into an integer array:
        float[] magData = float(split(inString, ","));
        // if the array has at least four elements, you know
        // you got the values plus the header.  Put the numbers 
        // in the magData array
        if (magData.length >=4) {
            if (magData[0] == 1.11) {  // test header
                
                Xval = (magData[1]/2) ;  // scale data to window
                Yval = (magData[2]/2) ;
                Zval = (magData[3]/2) ;
            }


            println((int)Xval + "\t" + (int)Yval + "\t" + (int)Zval );  


            //Xval = map(Xval, -1.0, 1.0, -200.0, 200.0);
            //Yval = map(Yval, -1.0, 1.0, -200.0, 200.0);
            //Zval = map(Zval, -1.0, 1.0, 200.0, -200.0);


            //println((int)Xval + "\t" + (int)Yval + "\t" + (int)Zval );  
            //// put points into the array

            //i =  ++i % (maxPoints - 2);  
            //x[i] = round(Xval);
            //z[i] = round(Yval);  //switch channels x<-> y why?
            //y[i] = round(Zval);  //switch channels x<-> y
        }
    }
}


void keyPressed() {  // spacebar erases drawing
    if (key == ' ') {
        background(20);
        setupGrid();
    }
}

void setupGrid() {
    fill(55, 300, 300);
    textSize(18);
    text("XY", width - 40, height - 100);
    fill(130, 300, 300);
    text("YZ", width - 40, height - 70);
    fill(280, 100, 300);
    text("XZ", width - 40, height - 40);
    stroke(0, 50, 50);
    for (int i =0; i < width; i+=(width/8)) {
        if (i == width/2) {
            stroke(0, 50, 100);
        } else stroke(0, 50, 50);
        line(i, 0, i, height);
        fill(0, 0, 250);
        text(i, i, 20);
    }
    for (int i =0; i < height; i+=(height/8)) {
        if (i == height/2) {
            stroke(0, 50, 100);
        } else stroke(0, 50, 50);
        line(0, i, width, i);
        fill(0, 0, 250);
        text(i, 20, i);
    }
}