

/*
Wolfram CA code

(C) Scott R. Harris
www.cheapscience.com



*/

#include "Tlc5940.h"
#define WORLDSIZE 16
#define RULE 30

byte World[]={0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0};
byte NewWorld[]={0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0};

byte m;
void setup()
{
   Tlc.init();
   Tlc.clear();
   Tlc.update();
   Serial.begin(115200);
//   Serial.println("Hello!");
//   Serial.println(wrap(0),DEC);
//      Serial.println(wrap(-1),DEC);
//         Serial.println(wrap(1),DEC);
//         
//               Serial.println(wrap(16),DEC);
               
//   Serial.println(0b00000001<<3,BIN);      
//   Serial.println(CARule(0,0,0,1),DEC);   
//      Serial.println(CARule(0,0,1,RULE),DEC);

TestCA();

   delay(100);
}

void loop()
{
  int k;
  byte a,b,c;
  
  for(k=0;k<16;k++)
    {
      a=World[wrap(k-1)];
      b=World[wrap(k)];
      c=World[wrap(k+1)];
      NewWorld[k]=CARule(a,b,c,RULE);
    }
    
    copy(NewWorld, World);
    
    for(k=0;k<16;k++)
      {
        Tlc.set(k,0);
        if(World[k])
          Tlc.set(k,2048);
      }
    Tlc.update();
    //PrintWorld();
    delay(50);
  
}



byte CARule(byte a, byte b, byte c, byte rule)
{
  return (rule & (0b00000001 << (a*4+b*2+c))) ? 1:0; 
}

void copy(byte *a, byte *b)
{
  int k;
  
  for(k=0;k<16;k++)
    b[k]=a[k];
  
}

byte wrap(int ind)
{
  
  ind =(ind % WORLDSIZE);
  if (ind<0)
    ind=(ind+WORLDSIZE);
    
  return (byte)ind;  
}

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
