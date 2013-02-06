

/*
Cellular Automata code for binary CA with Wolfram rule numbering.

Set up for a tape size of 16 since my TLC5940 board has 16 LEDs. 

Wrap-around boundary conditions.

(C) Scott R. Harris
scott@cheapscience.com
www.cheapscience.com

This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.

*/

#include "Tlc5940.h"
#define WORLDSIZE 16
#define RULE 30


//The cells are stored in a byte array. Very wasteful of space, but simple.
//Will be good when I move to multiple-state CAs

byte World[]={0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0};
byte NewWorld[]={0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0};

byte m;
void setup()
{
   Tlc.init();
   Tlc.clear();
   Tlc.update();
   
  
//   Serial.begin(115200);
//TestCA();

// delay(100);
}

void loop()
{
  int k;
  byte a,b,c;
  
  
  //We sweep through the cells and set a,b,c to be the left, middle, and right cell values
  //wrap does the wrap-around. e.g. -1 -> WORLDSIZE-1 and WORLDSIZE -> 0
  //CARule applies the rule number and computes the new cell value.
  
  for(k=0;k<16;k++)
    {
      a=World[wrap(k-1)];
      b=World[wrap(k)];
      c=World[wrap(k+1)];
      NewWorld[k]=CARule(a,b,c,RULE);
    }
    
    //We copy the new array to the old array after the entire new generation is computed.
    //Would be much faster with pointer swapping, but I did it this way for some reason
    
    copy(NewWorld, World);
    
    //Load the cell values into the TLC5940
    for(k=0;k<16;k++)
      {
        Tlc.set(k,0);
        if(World[k])
          Tlc.set(k,2048); //half brightness
      }
      
    Tlc.update(); //Push out the update to the LEDs

    delay(5); //sets the animaion rate.
  
}


//Applies Wolfram numbers CA rules to a byte array. 
//Legal values are 0 & 1 only.

byte CARule(byte a, byte b, byte c, byte rule)
{
  //Convert the three cells to a number and then the resulting state is that bit
  //picked out of the rule number.
  return (rule & (0b00000001 << (a*4+b*2+c))) ? 1:0; 
}


//Copies an array of bytes that is WORLDSIZE long

void copy(byte *a, byte *b)
{
  int k;
  
  for(k=0;k<WORLDSIZE;k++)
    b[k]=a[k];
  
}

//Wrap-around calculation. Modulo doens't work as I woudl like. Negative numbers are special.

byte wrap(int ind)
{
  
  ind =(ind % WORLDSIZE);
  if (ind<0)
    ind=(ind+WORLDSIZE);
    
  return (byte)ind;  
}

// Some test functions. Requires the serial port to be active.

void TestCA()
{
  int k;
  byte a,b,c;
  
  
  for(k=0;k<8;k++)
    {
      a=(k & 0b00000100) ? 1:0;
      b=(k & 0b00000010) ? 1:0;
      c=(k & 0b00000001) ? 1:0;
      Serial.print(k);
      Serial.print(" ");
      Serial.print(a, DEC);
      Serial.print(" ");
      Serial.print(b, DEC);
      Serial.print(" ");
      Serial.print(c, DEC);
      Serial.print(" ");
      Serial.print(CARule(a,b,c,30),DEC);
      Serial.println("");
    }
  
  
}


void PrintWorld()
{
  int k;
  for(k=0;k<16;k++)
    {
      Serial.print(World[k],DEC);
      Serial.print(" ");
    }
    Serial.println("");
}
