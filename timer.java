import java.text.DecimalFormat;

public class timer {

    public static void main(String[] args) throws InterruptedException {

        // Write the code here. You can run the code by 
        // selecting Run->Run File from the menu or by pressing Shift+F6
        int hh = 0, mm = 0, ss = 0;

        while (true) {
            ss++;
            if (ss == 60) {
                ss = 0;
                mm++;
                if (mm == 60) {
                    mm = 0;
                    hh++;
                }
            }

            System.out.print((new DecimalFormat("00").format(hh)) + ".");
            System.out.print((new DecimalFormat("00").format(mm)) + ".");
            System.out.print(new DecimalFormat("00" + "\n").format(ss));

            Thread.sleep(1000);
        }

    }

}

