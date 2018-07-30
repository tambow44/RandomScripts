/*
 * STEP THROUGH
 * 
 * ASK TOTAL BANDS (n)
 * 
 * ASK BAND COLOUR #1 - n
 * 
 *  // combiner means (1,2) = 12 | (3,4,5) = 345
 *  ^^ Electronics is super simple
 * 
 * if 3:
 *	1-2 = combiner
 *	3 	= multiplier
 * 
 * if 4:
 *  1-2 = combiner
 * 	3	= multiplier
 * 	4	= tolerance
 * 
 * if 5:
 * 	1-3 = combiner
 * 	4 	= multiplier
 * 	5	= tolerance
 * 
 * if 6:
 * 	same as 5
 * 	6 = TCR (temperature coefficient of resistor)
 * 
 */

import java.util.Scanner;

public class ResistorMain {

    public static void main(String arg[]){

        System.out.println("Resistor Colour Calculator\n");
        
        	Scanner sc = new Scanner(System.in);
        	
            // CAPTURE NUMBER OF BANDS:
            System.out.print("How many bands on your resistor? ");
            int numBands = sc.nextInt();
            
            while (numBands > 6 || numBands < 3) {
            	System.out.print("Please enter value between 3 - 6: ");
            	numBands = sc.nextInt();
            }
            
            System.out.print("Case: ");
            switch (numBands) {
            
            case 3:
            	System.out.println(numBands);
            	break;
            case 4:
            	
            	break;
            case 5:
            	
            	break;
            case 6:
            	
            	break;
            }

            int i = 1;
            while (i <= numBands) {
            	System.out.print(i);
            	i++;
           }
           
            sc.close();
    }
}
