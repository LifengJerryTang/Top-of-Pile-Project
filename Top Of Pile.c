/*
Name: Lifeng Jerry Tang
Date: 9/21/2019

This program loads a pile and finds the color of the topmost piece. */

#include <stdio.h>
#include <stdlib.h>

#define DEBUG 1 // RESET THIS TO 0 BEFORE SUBMITTING YOUR CODE

int main(int argc, char *argv[]) {
   int	             PileInts[1024];
   int	             NumInts, TopColor=0;
   int  Load_Mem(char *, int *);
   // This allows you to access the pixels (individual bytes)
   // as byte array accesses (e.g., Pile[25] gives pixel 25):
   char *Pile = (char *)PileInts;

   if (argc != 2) {
     printf("usage: ./P1-1 valuefile\n");
     exit(1);
   }
   NumInts = Load_Mem(argv[1], PileInts);
   if (NumInts != 1024) {
      printf("valuefiles must contain 1024 entries\n");
      exit(1);
   }

   if (DEBUG){
     printf("Pile[0] is Pixel 0: 0x%02x\n", Pile[0]);
     printf("Pile[107] is Pixel 107: 0x%02x\n", Pile[107]);
   }

   /* Your program goes here */

   int overlapOrNot[] = {1, 0, 0, 0, 0, 0, 0, 0}; /*Instantiate an array of "is being covered by another color"
                                                    flag for all the colors. The index of the array corresponds to
                                                    the number for each color: index 0 is the flag for black, 1 is for
                                                    pink...*/


   for (int a = 1; a < 8; a++) { /*Set the for loop to run 7 times for every color that's other than black, since black is
                                   the bottom most color*/

        for(int i = 0; i < 64 && !overlapOrNot[a]; i++) { //Make an nested loop to check every single pixel
            for(int j = 0; j < 64; j++){

            int currentColor = (int)Pile[i * 64 + j]; //Declare the color at a certain time to the variable currentColor

            if(a == currentColor) { /*Check if the color that we are checking right now is the same as the current color
                                      we are at*/

                if(a == (int)Pile[i * 64 + j + 2] && a != (int)Pile[i * 64 + j + 1]) { /*Check if the current color
                                                                                         equals the second color that's ahead
                                                                                         and does not equal the next color*/

                   if (a != (int)Pile[i * 64 + j - 64] && (int)Pile[i * 64 + j + 1] != 0
                       && a != (int)Pile[i * 64 + j + 64]) {  /*If our current color does not equal the color above and
                                                                below, (and those colors are not black) then the current
                                                                color that we are at is under another color. We will set
                                                                the flag that corresponds to our current color to 1*/
                         overlapOrNot[a] = 1;
                         break;

                   }

                } else if (a == (int)Pile[i * 64 + j + 2 * 64] && a != (int)Pile[i * 64 + j + 64]) { /*Check if the current
                                                                                        color equals the second color that's
                                                                                        below and does not equal the color
                                                                                        below*/

                     if (a != (int)Pile[i * 64 + j - 1] && a != (int)Pile[i * 64 + j + 1]
                         && (int)Pile[i * 64 + j + 64] != 0) { /*If our current color does not equal the color behind and
                                                                 the color ahead, (and those colors are not black)
                                                                 then the current color that we are at is under another color.
                                                                 We will set the flag that corresponds to our current
                                                                 color to 1*/
                         overlapOrNot[a] = 1;
                         break;

                 }
              }
            }
         }
      }
   }

   for (int b = 1; b < 8; b++) {  /*Check which color's flag is not raised to 1*/

        if(overlapOrNot[b] == 0) {

            TopColor = b; //Our color is found and set it to TopColor
            break;

        }
   }

   printf("The topmost part color is: %d\n", TopColor);
   exit(0);
}



/* This routine loads in up to 1024 newline delimited integers from
a named file in the local directory. The values are placed in the
passed integer array. The number of input integers is returned. */

int Load_Mem(char *InputFileName, int IntArray[]) {
   int	N, Addr, Value, NumVals;
   FILE	*FP;

   FP = fopen(InputFileName, "r");
   if (FP == NULL) {
      printf("%s could not be opened; check the filename\n", InputFileName);
      return 0;
   } else {
      for (N=0; N < 1024; N++) {
         NumVals = fscanf(FP, "%d: %d", &Addr, &Value);
         if (NumVals == 2)
            IntArray[N] = Value;
         else
            break;
      }
      fclose(FP);
      return N;
   }
}
