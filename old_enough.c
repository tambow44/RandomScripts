#include <stdio.h>

#define LOWER (your_age / 2) + 7
#define UPPER (your_age -7) * 2

int main(void)
{
   float your_age, their_age;

   printf("Are they old enough?\n-----\n");

   printf("Enter your age: ");
    scanf("%f", &your_age);

   printf("Enter their age: ");
    scanf("%f", &their_age);

   if (LOWER > their_age) {

      printf("THEY ARE TOO YOUNG FOR YOU ! ! !\n");
      printf("DON'T FUCK ANYONE YOUNGER THAN: %.1f\n", LOWER);

      if (your_age > 18.0 && their_age < 18.0) {
         printf("---\nTHEY'RE UNDERAGE, YOU NONCE ! ! !\n");
      }

      return 0;

   } else if (UPPER < their_age) {

      printf("THEY ARE TOO OLD FOR YOU ! ! !\n");
      printf("DON'T FUCK ANYONE OLDER THAN: %.1f\n", UPPER);

      if (their_age > (UPPER + 20)) {
         printf("YOU'RE ENTERING GRAVE-ROBBING STATUS\n");
      }
      return 0;

   } else {

      if (their_age == your_age) {
         printf("You are shite at math, but . . .\n");
      }

      printf("THEY ARE GOOD TO GO ! ! !\n");

   }

   return 0;
}
